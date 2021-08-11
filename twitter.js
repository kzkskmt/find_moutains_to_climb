const fs = require("fs");
let Twitter = require('twitter');
require('dotenv').config();

let client = new Twitter({
    consumer_key: process.env.TWITTER_API_KEY,
    consumer_secret: process.env.TWITTER_API_SECRET_KEY,
    access_token_key: process.env.TWITTER_ACCESS_TOKEN,
    access_token_secret: process.env.TWITTER_ACCESS_TOKEN_SECRET
});


const main = async () => {
    const stream = await client.stream('statuses/filter', {'track':'#甲武信ヶ岳'});
    stream.on('data', async data => {
        try {
            fs.appendFile("tweet/tweet.csv", JSON.stringify(data) + "\n", (err) => {
                if (err) throw err;
                console.log("正常に書き込みが完了しました");
            });

        } catch (error) {
            console.log(error);
        }
    });
};

main();