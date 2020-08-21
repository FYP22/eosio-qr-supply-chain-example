import json

if __name__ == "__main__":

    account = input('Enter in the account to allow actions: ')
    location = input('Enter in location of scanner: ')

    with open('config.json', 'r') as config:
        data = json.load(config)

    data['account'] = account
    data['location'] = location

    with open('config.json', 'w') as config:
        json.dump(data, config)