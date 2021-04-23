# Emulate call the VeChain Random
import time
import sys
from thor_requests.connect import Connect
from thor_requests.wallet import Wallet
from thor_requests.contract import Contract
from thor_requests import utils

# Global params
TOP = 220
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

# Emulate the call of getting a random number
if not utils.is_contract(c.get_account(CONTRACT_ADDRESS)):
    raise Exception(f"{CONTRACT_ADDRESS} is not a smart contract")

# best block
# block = c.get_block()
# best_block_number = int(block['number'])
winners = set()
best_block_number = 8859801
for i in range(200):
    response = c.call(w.getAddress(), smart_contract, '_getRandomNumber', [TOP, best_block_number + i], CONTRACT_ADDRESS)
    if response['reverted']:
        print(response)
    else:
        winner = int(response['decoded']['0'])
        if winner in winners:
            print(f"{winner} already in the pool!")
        else:
            winners.add(winner)
            if len(winners) >= 50:
                break

for each in winners:
    print(each)

# # Track the future blocks
# for i in range(5):
#     time.sleep(SLEEP)
#     response = c.call(w.getAddress(), smart_contract, 'quickRandomNumber', [TOP], CONTRACT_ADDRESS)
#     if response['reverted']:
#         print(response)
#     else:
#         print(response['decoded']['0'])