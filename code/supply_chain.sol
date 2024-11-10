// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract SupplyChain {
    enum State { Created, InTransit, Delivered }

    struct Product {
        uint id;
        string name;
        address owner;
        State state;
    }

    uint public productCount = 0;
    mapping(uint => Product) public products;

    event ProductCreated(uint id, string name, address owner, State state);
    event StateUpdated(uint id, State state);
    event OwnershipTransferred(uint id, address previousOwner, address newOwner);
    event DebugProductCount(uint beforeIncrement, uint afterIncrement);

    function createProduct(string memory _name) public {
        productCount++;
        products[productCount] = Product(productCount, _name, msg.sender, State.Created);
        emit ProductCreated(productCount, _name, msg.sender, State.Created);
    }


    

    function updateState(uint _id, State _state) public {
        require(products[_id].owner == msg.sender, "Apenas o proprietario pode atualizar o estado.");
        products[_id].state = _state;
        emit StateUpdated(_id, _state);
    }

    function transferOwnership(uint _id, address _newOwner) public {
        require(products[_id].owner == msg.sender, "Apenas o proprietario pode transferir a propriedade.");
        address previousOwner = products[_id].owner;
        products[_id].owner = _newOwner;
        emit OwnershipTransferred(_id, previousOwner, _newOwner);
    }

    function stateToString(State _state) internal pure returns (string memory) {
        if (_state == State.Created) return "Created";
        if (_state == State.InTransit) return "InTransit";
        if (_state == State.Delivered) return "Delivered";
        return "Unknown";
    }

    // Função para visualizar detalhes do produto
    function getProduct(uint _id) public view returns (uint, string memory, address, string memory) {
        Product memory product = products[_id];
        string memory stateString = stateToString(product.state);
        return (product.id, product.name, product.owner, stateString);
    }
}

