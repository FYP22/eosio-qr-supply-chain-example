const express = require('express');

// eosjs constants

const { Api, JsonRpc, RpcError } = require('eosjs');
const { JsSignatureProvider } = require('eosjs/dist/eosjs-jssig');      // development only
const fetch = require('node-fetch');                                    // node only; not needed in browsers
const { TextEncoder, TextDecoder } = require('util'); 

const rpc = new JsonRpc('http://nodeos:8888', { fetch });
const defaultPrivateKey = "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3";  // replace with .env file
const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);

const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });

// app init
const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.post('/api/update', async (req,res) => {
    try {
        console.log(req.body);
        res.send(req.body);
        const result = await api.transact(
            {
                actions: [{
                    account: 'tracker',
                    name: 'update',
                    authorization: [{
                        actor: req.body.account,
                        permission: 'active',
                    }],
                    data: {
                        id: req.body.id,
                        account: req.body.account,
                        location: req.body.location
                    },
                }]
            }, {
                blocksBehind: 3,
                expireSeconds: 30
            });
        console.log(result);
    } catch (e) {
        console.log('\nCaught exception: ' + e);
        if (e instanceof RpcError) {
            console.log(JSON.stringify(e.json, null, 2));
        }
    }
});

// constants
const PORT = 8080;
const HOST = '0.0.0.0';
app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`)