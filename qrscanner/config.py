import json
import sys

if __name__ == "__main__":

    data = {}

    location = sys.argv[2] + ' ' + sys.argv[3]

    data['account'] = sys.argv[1]
    data['location'] = location

    with open('config.json', 'w+') as config:
        json.dump(data, config)