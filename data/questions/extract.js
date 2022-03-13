// Load the Snowflake Node.js driver.
var snowflake = require('snowflake-sdk');

// Create a Connection object that we can use later to connect.
var connection = snowflake.createConnection( {
    account:  process.env.SF_ACCOUNT,
    username: process.env.SF_USERNAME,
    password: process.env.SF_PASSWORD,
    //clientSessionKeepAlive: true
    }
    );

const express = require('express');
const https = require('https');
const app = express()
const port = 3333
const axios = require('axios');
var snowflakeConnected = false;

app.get('/', (req, res) => {
    res.send('Hello World!')
})

app.get('/api', (req, res) => {
    if (snowflakeConnected === false)
    {
        res.send("WAIT_SNOWFLAKE")
        return;
    }
    if (req.query.q === 'getQuestions')
    {
        axios.get("https://flipsidecrypto.xyz/?_data=routes%2Findex")
        .then(axios_return => {
            var date = new Date();
            var dateTrunc = date.toISOString();
            var dateFinal = dateTrunc;

            connection.execute({
            sqlText: "insert into community.antonyip.src_flipside_bounties values (:1,:2)",
            binds: [dateFinal, '{ "type" : "getQuestions", subtype:"'+req.query.q+'", "data":' + JSON.stringify(axios_return.data) + '}'],
            complete: function(err, stmt, rows) {
                    if (err)
                    {
                        console.log(err);
                        res.send("ERROR_SNOWFLAKE");
                        return;
                    }
                    else
                    {
                        res.send("OK");
                    }
                }
            });
        })
        .catch(error => {
            console.error(error)
            res.send("RETRY")
        })
    }

    else
    {
        res.send("Invalid Endpoint")
    }
})

// Try to connect to Snowflake, and check whether the connection was successful.
connection.connect( 
    function(err, conn) {
        if (err) {
            console.error('Unable to connect: ' + err.message);
            } 
        else {
            snowflakeConnected = true;
            console.log('Successfully connected to Snowflake.');
            // Optional: store the connection ID.
            connection_ID = conn.getId();
            }
        }
    );

app.listen(port, () => {
    console.log(`Bounty Hunter listening on port ${port}`)
})