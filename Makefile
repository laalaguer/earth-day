export network=http://solo.veblocks.net
export private=dce1443bd2ef0c2631adc1c67e5c93f13dc23a41c18b536effbbdcbcdb96fb65 # address: 0x7567d83b7b8d80addcb281a71d54fc7b3364ffed
export rand_contract=./rand/build/contracts/VeChainRandom.json
export rand_address=0x3aa8a158c48204d4ee096eb875dd3ed76e032bc5
export crowd_contract=./crowd/build/contracts/Crowd.json
export blocks_later=180
export crowd_address=0x4dab493f65b315356df919996d93ed4bfab7235b

# export network=http://testnet.veblocks.net
# export private=dce1443bd2ef0c2631adc1c67e5c93f13dc23a41c18b536effbbdcbcdb96fb65 # address: 0x7567d83b7b8d80addcb281a71d54fc7b3364ffed
# export rand_contract=./rand/build/contracts/VeChainRandom.json
# export rand_address=0x3dc82679f25f7091221fa969bfe50b902a457f16
# export crowd_contract=./crowd/build/contracts/Crowd.json
# export blocks_later=180
# export crowd_address=0xec16aef9cab3494f984765bab1d54a1fefd03f20

# export network=http://mainnet.veblocks.net
# export private=dce1443bd2ef0c2631adc1c67e5c93f13dc23a41c18b536effbbdcbcdb96fb65 # address: 0x7567d83b7b8d80addcb281a71d54fc7b3364ffed
# export rand_contract=./rand/build/contracts/VeChainRandom.json
# export rand_address=0x33c6c1f54434be9e26b2026b44b715cb8e7d61df
# export crowd_contract=./crowd/build/contracts/Crowd.json
# export blocks_later=180
# export crowd_address=0xec16aef9cab3494f984765bab1d54a1fefd03f20

# 2.4912 VTHO
deploy_rand:
	. .env/bin/activate && python3 deploy.py $(network) $(private) $(rand_contract)

emulate_rand:
	. .env/bin/activate && python3 emulate.py $(network) $(private) $(rand_contract) $(rand_address)

deploy_crowd:
	. .env/bin/activate && python3 deploy_crowd.py $(network) $(private) $(crowd_contract) $(blocks_later)

emulate_crowd:
	. .env/bin/activate && python3 emulate_crowd.py $(network) $(private) $(crowd_contract) $(crowd_address)