## Customers KYC for Bank

     This is an open source project to create boiler plate code set up for a simple Node JS server.
     
        * Swagger has also been implemented for easier documentation.
        * Jest set up is also there to support testing.
        * Docker set up has been made to make life easier.
        * Inputs to REST API can be validated here using ajv.
        * Mongoose is here to help you with the database schema and connection.

## What is this repository for?

    Stock Exchange Interface.

    Version:- 1.0
    Git clone :-https://github.com/debrajpaul/customersKYCForBank.git

## How do I get set up?

    Set up all dependencies mentioned below
    Summary of set up:- Clone the file from repository and follow the "deployment instructions".

## Server Configuration:-

    Node 10 software (Ubuntu 18.04, Link:- https://nodejs.org/en/)
    Truffle framework (Link:- https://trufflesuite.com/truffle/)
    Ganache Blockchain (Link:- https://trufflesuite.com/ganache/)

## Dependencies

    All dependencies are listed in package.json file
    * In terminal go to your project directory
    * In terminal type "truffle compile" to add all dependencies.

## truffle-config.js file

```
development: {
    host: "127.0.0.1",     // Localhost (default: none)
    port: 7545,            // Standard Ethereum port (default: none)
    network_id: 5777,       // Any network (default: none)
},
```

## Deployment instructions:-

    In terminal go to your project directory
    * edit the truffle-config.js file to the project root directory
    * In terminal type "truffle develop" to go into truffle develop cli.
    * In terminal type "truffle migrate" to deploy the contact.

## UNIT TEST SUITE

    In terminal go to your project directory
    * edit the truffle-config.js file to the project root directory
    * Type truffle test
## How to Contribute

Find any typos? Have another resource you think should be included? Contributions are welcome!

First, fork this repository.

![Fork Icon](images/fork-icon.png)

Next, clone this repository to your desktop to make changes.

```sh
$ git clone {YOUR_REPOSITORY_CLONE_URL}
$ cd customersKYCForBank
```

Once you've pushed changes to your local repository, you can issue a pull request by clicking on the green pull request icon.

![Pull Request Icon](images/pull-request-icon.png)

Instead of cloning the repository to your desktop, you can also go to `README.md` in your fork on GitHub.com, hit the Edit button (the button with the pencil) to edit the file in your browser, then hit the `Propose file change` button, and finally make a pull request.

## Who do I talk to?

    Debraj Paul
    contact info:- pauldebraj7@gmail.com
    LinkedIn:- https://www.linkedin.com/in/debraj-paul

## License

        Apache License
