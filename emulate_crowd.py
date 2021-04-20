# Emulate call the VeChain Random
import time
import sys
from thor_requests.connect import Connect
from thor_requests.wallet import Wallet
from thor_requests.contract import Contract
from thor_requests import utils

# Global params
TOP = 20000
SLEEP = 11

# Read in Params
SCRIPT_NAME = sys.argv[0]
NETWORK = sys.argv[1] # eg. 'https://solo.veblocks.net'
PRIVATE_KEY = sys.argv[2]
COMTRACT_FILE = sys.argv[3]
CONTRACT_ADDRESS = sys.argv[4]

# Prepare wallet and network
w = Wallet.fromPrivateKey(bytes.fromhex(PRIVATE_KEY))
c = Connect(NETWORK)
smart_contract = Contract.fromFile(COMTRACT_FILE)

# Detect wallet balance
account = c.get_account(w.getAddress())
print('Wallet:')
print('VET:', int(account['balance'], 16) / (10 ** 18))
print('VTHO:', int(account['energy'], 16) / (10 ** 18))
print('Is human:', not utils.is_contract(account))

if not utils.is_contract(c.get_account(CONTRACT_ADDRESS)):
    raise Exception(f"{CONTRACT_ADDRESS} is not a smart contract")

# Emulate call of current block number/stop block number
block = c.get_block()
best_block_number = int(block['number'])
print('best block:', best_block_number)

response = c.call(w.getAddress(), smart_contract, 'stopBlockNumber', [], CONTRACT_ADDRESS)
print('stopBlockNumber:', response['decoded']['0'])

response = c.call(w.getAddress(), smart_contract, 'allowDuplicate', [], CONTRACT_ADDRESS)
print('allow multiple deposits:', response['decoded']['0'])

# Check user balance
response = c.call(w.getAddress(), smart_contract, 'balanceOf', [w.getAddress()], CONTRACT_ADDRESS)
print('User balance in contract:', int(response['decoded']['0']) / (10**18), 'VET')

# Deposit 1 vet into the smart contract
# Check user balance
# Check user position
response = c.commit(w, smart_contract, 'deposit', [], CONTRACT_ADDRESS, 1 * (10**18))
tx_id = response['id']
receipt = c.wait_for_tx_receipt(tx_id)
print('User deposit receipt:', receipt)

response = c.call(w.getAddress(), smart_contract, 'balanceOf', [w.getAddress()], CONTRACT_ADDRESS)
print('User balance in contract:', int(response['decoded']['0']) / (10**18), 'VET')

response = c.call(w.getAddress(), smart_contract, 'countUsers', [], CONTRACT_ADDRESS)
print('User counts in contract:', int(response['decoded']['0']))

# Deposit 2 vet into the smart contract
# Check user balance
# Check user position (shall remain the same!)
response = c.commit(w, smart_contract, 'deposit', [], CONTRACT_ADDRESS, 2 * (10**18))
tx_id = response['id']
receipt = c.wait_for_tx_receipt(tx_id)
print('User deposit receipt:', receipt)

response = c.call(w.getAddress(), smart_contract, 'balanceOf', [w.getAddress()], CONTRACT_ADDRESS)
print('User balance in contract:', int(response['decoded']['0']) / (10**18), 'VET')

response = c.call(w.getAddress(), smart_contract, 'countUsers', [], CONTRACT_ADDRESS)
print('User counts in contract:', int(response['decoded']['0']))

# Withdraw all the VET back to (owner)
response = c.call(w.getAddress(), smart_contract, 'total', [], CONTRACT_ADDRESS)
print('How many VET in contract?', int(response['decoded']['0']) / (10 ** 18))
# Take them all
response = c.commit(w, smart_contract, 'withdraw', [w.getAddress()], CONTRACT_ADDRESS)
print('Withdraw tx:', response)