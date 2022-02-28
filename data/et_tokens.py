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
