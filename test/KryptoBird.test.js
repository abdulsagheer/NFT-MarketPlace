const {assert} = require('chai');

const KryptoBird = artifacts.require('./Kryptobird');

// check for chai
require('chai').use(require('chai-as-promised')).should()

contract('KryptoBird', (accounts) => {
    
    let contract;
    // before tells our tests to run this first before anything else.
    before( async() => {
        contract = await KryptoBird.deployed()
    })
    
    // testing container
    describe('Deployment', async() => {
        // test samples with writing it.
        it('deploys successfully', async() => {
            const address = contract.address;
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        });

        // test for name matching successfully.
        it("name matches on our contract successfully", async() => {
        const name = await contract.name();
        assert.equal(name, "KryptoBird");
        });

        // test for name matching successfully.
        // test for symbol matching 
        it("symbol matches on our contract successfully", async() => {
        const symbol = await contract.symbol();
        assert.equal(symbol, "KBIRDZ");
        });
    });

    describe('Minting', async() => {
      it("Creates a new token", async() => {
        const result = await contract.mint("https...1");
        const totalSupply = await contract.totalSupply();

        // succesful
        assert.equal(totalSupply, 1);
        const event = result.logs[0].args;
        assert.equal(
          event._from,
          "0x0000000000000000000000000000000000000000",
          "from is the contract"
        );
        assert.equal(event._to, accounts[0], "to is msg.sender");

        // failure
        await contract.mint("https...1").should.be.rejected;
      });
    })
    describe('indexing', async() => {
        it("lists KryptoBird", async() => {
            
            // Mint 3 tokens
            await contract.mint("https...2");
            await contract.mint("https...3");
            await contract.mint("https...4");
            const totalSupply = await contract.totalSupply();

            // Loop through list and grab KBirdz from list
            let result = [];
            let KryptoBird;
            
            for (i = 1; i <= totalSupply; i++) {
                KryptoBird = await contract.kryptoBirdz(i - 1);
                result.push(KryptoBird);
            }

            // assert that our result will equal our expected result and
            let expected = ['https...1', 'https...2', 'https...3', 'https...4']
            assert.equal(result.join(","), expected.join(","));
        });
    })
})