##### Overview

- [spaceship-test-service] is a node.js backend which fetches prices from external API provider regularly and exposes APIs for the frontend.
- [spaceship-test-web] is a react single page app. It uses apis from spaceship-test-service.

#### Run project on local

option 1:
- Setup a coingecko demo api key at https://www.coingecko.com/en/developers/dashboard or you can ask me for mine one
- export the key by export COINGECKO_API_KEY=$COINGECKO_API_KEY
- run yarn start

option 2
- open two terminal and run each project seperately
- on spaceship-test-back, run docker-compose up -d and yarn start:dev, create .env or export the COINGECKO_API_KEY on zsh
- on spaceship-test-web, run yarn start

##### Design

- The application is real time, so the backend uses server-sent event to broadcast price update to the frontend because:
  1. real time can be updating the UI per tick/1 sec/ 1 min/ 1 hour. I assume the price can be updating every second so polling is not optimal.
  2. Users do not push events to backend so websocket is not needed.
- Considering calling API would cost money, the backend would fetch the price and store it at cache and all the clients should get the price from cache at the beginning. Even if the user spam refresh it will not hit the upstream service.
- The application is real-time, so using redis is enough because we don't need to persist data.

[Click for design diagram](./docs/design.png)

##### Limitation

- https://www.cryptonator.com/api/ is not available anymore so I switched to Coingecko.
- Coingecko free demo API has a very low rate limit so I can only run cronjob every 1 min, the feature is still real-time but it does not look like it is.
- Coingecko free demo API always returns the same data, and again, the feature is real-time but the UI doesn't look real-time.

##### Improvement

- For simplicity, currently the backend only has one service that do all the job (fetching prices, broadcasting), I think it could be seperated into two services and communicate using message queue, one only fetches prices regularly from the API and the other one broadcast/expose prices to clients.
- On the cloud environment we might have horizontal scaling but the service that runs cronjob to fetch data can be restricted to a single instance.
