pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint public productCount = 0;

    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;  //付钱给所有者
        bool purchased;
    }

    mapping(uint => Product) public products;

    constructor() public {
        name = "Dapp University Marketplace";
    } 

    event ProductCreated (
        uint id,
        string name,
        uint price,
        address payable owner,
        bool purchased
    );

    event ProductPurchased(
    uint id,
    string name,
    uint price,
    address payable owner,
    bool purchased
    );

    //创建新产品
    function createProduct(string memory _name, uint _price) public {
        //需要一个有效的名称
        require(bytes(_name).length > 0);
        //需要一个有效的价格
        require(_price > 0);
        //产品数量递增
        productCount ++;
        //创建一个产品
        products[productCount] = Product(productCount, _name, _price, msg.sender, false);
        //触发事件
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    //购买产品
    function purchaseProduct(uint _id) public payable {
        //获取产品
        Product memory _product = products[_id];

        //获取卖方address
        address payable _seller = _product.owner;

        //检查产品id的有效性
        require(_product.id > 0 && _product.id <= productCount);

        //要求有足够的Ether进行交易
        require(msg.value >= _product.price);

        //需要产品没有被购买
        require(!_product.purchased);

        //购买者不能与出售者是同一个人
        require(_seller != msg.sender);

        _product.owner = msg.sender;

        _product.purchased = true;
        //更新产品
        products[_id] = _product;
        //将Ether支付给卖方
        address(_seller).transfer(msg.value);

        emit ProductPurchased(productCount, _product.name, _product.price, msg.sender, true);

    }
}