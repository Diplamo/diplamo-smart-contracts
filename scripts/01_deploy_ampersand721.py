from brownie import ampersand721, config, network
from web3 import Web3
from scripts.helpful_scripts import (
    get_account,
    get_contract,
)


def deploy_lillup_nft():
    jobId = config["networks"][network.show_active()]["jobId"]
    fee = config["networks"][network.show_active()]["fee"]
    account = get_account()
    oracle = get_contract("oracle").address
    link_token = get_contract("link_token").address
    api_consumer = ampersand721.deploy(
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    print(f"lillup NFT contract deployed to {api_consumer.address}")
    return api_consumer


def main():
    deploy_lillup_nft()
