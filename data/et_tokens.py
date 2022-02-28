import json

file = open("et_tokens.json")
data = json.loads(file.read())

print("token_address,token_name,token_symbol,decimals")
for lpPool in data["mainnet"]:
    try:
        name = data["mainnet"][lpPool]["name"]
    except:
        name = ""
    symbol = data["mainnet"][lpPool]["symbol"]
    try:
        decimals = data["mainnet"][lpPool]["decimals"]
    except:
        decimals = 0
    line = lpPool+",\""+name+"\",\""+symbol+"\","+str(decimals)
    
    print(line)

## Additional tables -- if you need it 
print('terra1dj2cj02zak0nvwy3uj9r9dhhxhdwxnw6psse6p,"NIO Inc.","mNIO",6')
print('terra1qsnj5gvq8rgs7yws8x5u02gwd5wvtu4tks0hjm,"Coca-Cola","mKO",6')
print('terra15k5r9r8dl8r7xlr29pry8a9w7sghehcnv5mgp6,"LUNAVERSE","LUV",6')
print('terra15tztd7v9cmv0rhyh37g843j8vfuzp8kw0k5lqv,"altered","ALTE",6')
print('terra1kkyyh7vganlpkj0gkc2rfmhy858ma4rtwywe3x,"USD Coin (PoS) (Wormhole)","USDC",6')
print('terra1pvel56a2hs93yd429pzv9zp5aptcjg5ulhkz7w,"USD Coin (Wormhole)","USDC.e",6')
