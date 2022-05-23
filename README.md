# Contact List Server

The project uses libraries and frameworks:

-   Express
-   MySQL2
-   JSON Web Token

## Project Setup

```sh
npm install
```

### Run for Development

```sh
npm run dev
```

### Run for Production


- With process manager:

```sh
pm2 start index.js --name "contact-list-api" --node-args="-r dotenv/config"
```
