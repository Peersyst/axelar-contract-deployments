const { Command, Option } = require('commander');
const { TxBuilder, updateMoveToml } = require('@axelar-network/axelar-cgp-sui');
const { bcs } = require('@mysten/sui.js/bcs');
const { fromB64, toB64 } = require('@mysten/bcs');
const { saveConfig, printInfo, validateParameters, prompt, writeJSON } = require('../evm/utils');
const { addBaseOptions } = require('./cli-utils');
const { getWallet } = require('./sign-utils');
const { loadSuiConfig } = require('./utils');

async function upgradePackage(client, keypair, packageConfig, builder, options) {
    const { modules, dependencies, digest } = await builder.getContractBuild('its');
    const { policy, offline, sender } = options;

    const upgradeCap = packageConfig.objects?.UpgradeCap;
    const digestHash = options.digest ? fromB64(options.digest) : digest;

    validateParameters({ isNonEmptyString: { upgradeCap, policy }, isNonEmptyStringArray: { modules, dependencies } });

    const tx = builder.tx;
    const cap = tx.object(upgradeCap);

    const ticket = tx.moveCall({
        target: `0x2::package::authorize_upgrade`,
        arguments: [cap, tx.pure(policy), tx.pure(bcs.vector(bcs.u8()).serialize(digestHash).toBytes())],
    });

    const receipt = tx.upgrade({
        modules,
        dependencies,
        packageId: packageConfig.address,
        ticket,
    });

    tx.moveCall({
        target: `0x2::package::commit_upgrade`,
        arguments: [cap, receipt],
    });

    sender ? tx.setSender(sender) : tx.setSender(keypair.toSuiAddress());
    const txBytes = await tx.build({ client });

    if (offline) {
        options.txBytes = txBytes;
    } else {
        const signature = (await keypair.signTransactionBlock(txBytes)).signature;
        const result = await client.executeTransactionBlock({
            transactionBlock: txBytes,
            signature,
            options: {
                showEffects: true,
                showObjectChanges: true,
                showEvents: true,
            },
        });

        const packageId = (result.objectChanges?.filter((a) => a.type === 'published') ?? [])[0].packageId;
        packageConfig.address = packageId;
        printInfo('Transaction result', JSON.stringify(result, null, 2));
        printInfo(`ITS upgraded`, packageId);
    }
}

async function deployPackage(chain, client, keypair, itsContractConfig, builder, options) {
    const { offline, sender } = options;

    const address = sender || keypair.toSuiAddress();
    await builder.publishPackageAndTransferCap('its', address);
    const tx = builder.tx;
    tx.setSender(address);
    const txBytes = await tx.build({ client });

    if (offline) {
        options.txBytes = txBytes;
    } else {
        if (prompt(`Proceed with deployment on ${chain.name}?`, options.yes)) {
            return;
        }

        const signature = (await keypair.signTransactionBlock(txBytes)).signature;
        const publishTxn = await client.executeTransactionBlock({
            transactionBlock: txBytes,
            signature,
            options: {
                showEffects: true,
                showObjectChanges: true,
                showEvents: true,
            },
        });

        const packageId = (publishTxn.objectChanges?.find((a) => a.type === 'published') ?? []).packageId;
        itsContractConfig.address = packageId;
        const ITS = publishTxn.objectChanges.find((change) => change.objectType === `${packageId}::its::ITS`);
        const upgradeCap = publishTxn.objectChanges.find((change) => change.objectType === `0x2::package::UpgradeCap`);
        itsContractConfig.objects = {
            ITS: ITS.objectId,
            UpgradeCap: upgradeCap.objectId,
        };

        printInfo(`ITS deployed`, JSON.stringify(itsContractConfig, null, 2));
    }
}

async function processCommand(chain, options) {
    const [keypair, client] = getWallet(chain, options);
    const { upgrade, offline, txFilePath } = options;

    printInfo('Wallet address', keypair.toSuiAddress());

    if (!chain.contracts.its) {
        chain.contracts.its = {};
    }

    const contractsConfig = chain.contracts;
    const itsContractConfig = contractsConfig.its;

    for (const dependencies of ['axelar_gateway','abi','governance']) {
        const packageId = contractsConfig[dependencies]?.address;
        updateMoveToml(dependencies, packageId);
    }

    const builder = new TxBuilder(client);

    if (upgrade) {
        await upgradePackage(client, keypair, itsContractConfig, builder, options);
    } else {
        await deployPackage(chain, client, keypair, itsContractConfig, builder, options);
    }

    if (offline) {
        validateParameters({ isNonEmptyString: { txFilePath } });

        const txB64Bytes = toB64(options.txBytes);

        writeJSON({ status: 'PENDING', bytes: txB64Bytes }, txFilePath);
        printInfo(`The unsigned transaction is`, txB64Bytes);
    }
}

async function mainProcessor(options, processor) {
    const config = loadSuiConfig(options.env);

    await processor(config.sui, options);
    saveConfig(config, options.env);
}

if (require.main === module) {
    const program = new Command();

    program.name('deploy-its').description('Deploy/Upgrade the Sui ITS');

    addBaseOptions(program);

    program.addOption(new Option('--upgrade', 'deploy or upgrade ITS'));
    program.addOption(new Option('--policy <policy>', 'new policy to upgrade'));
    program.addOption(new Option('--sender <sender>', 'transaction sender'));
    program.addOption(new Option('--digest <digest>', 'digest hash for upgrade'));
    program.addOption(new Option('--offline', 'store tx block for sign'));
    program.addOption(new Option('--txFilePath <file>', 'unsigned transaction will be stored'));

    program.action((options) => {
        mainProcessor(options, processCommand);
    });

    program.parse();
}
