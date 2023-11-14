1// SPDX-License-Identifier: UNLICENSED  
2pragma solidity ^0.8.20;  
3  
4import "@openzeppelin/contracts/token/ERC721/ERC721.sol";  
5import "./MyERC20.sol";  
6  
7// ERC721 contract for issuing car NFTs  
8contract BorrowYourCar is ERC721 {  
9    uint256 public tokenIdCounter;  
10    MyERC20 public myERC20; // Token contract for lottery-related tokens  
11  
12    // Car struct  
13    struct Car {  
14        address owner; // Car owner  
15        address borrower; // Car borrower  
16        uint256 borrowedTime; // Time when the car was borrowed  
17        uint256 borrowedTimeDuration; // Expected borrowing duration  
18    }  
19  
20    mapping(uint256 => Car) private _cars; // Mapping from car NFT ID to car  
21  
22    constructor() ERC721("Car", "cNFT") {  
23        myERC20 = new MyERC20("CarNFTToken", "CarNFTTokenSymbol");  
24        tokenIdCounter = 0;  
25    }  
26  
27    function totalSupply() public view returns (uint256) {  
28        return tokenIdCounter;  
29    }  
30  
31    function exists(uint256 tokenId) public view returns (bool) {  
32        return _cars[tokenId].owner != address(0);  
33    }  
34  
35    // Issue a new car NFT  
36    function mintCar() public {  
37        tokenIdCounter++;  
38        _mint(msg.sender, tokenIdCounter);  
39        _cars[tokenIdCounter].owner = msg.sender;  
40    }  
41  
42    // Get a list of cars owned by a user  
43    function getOwnedCars(address user) external view returns (uint256[] memory) {  
44        uint256[] memory ownedCars = new uint256[](tokenIdCounter);  
45        uint256 counter = 0;  
46        for (uint256 i = 1; i <= tokenIdCounter; i++) {  
47            if (ownerOf(i) == user) {  
48                ownedCars[counter] = i;  
49                counter++;  
50            }  
51        }  
52        return ownedCars;  
53    }  
54  
55    // Get a list of cars that are currently not borrowed  
56    function getAvailableCars() external view returns (uint256[] memory) {  
57        uint256[] memory availableCars = new uint256[](tokenIdCounter);  
58        uint256 counter = 0;  
59        for (uint256 i = 1; i <= tokenIdCounter; i++) {  
60            if (_cars[i].borrower == address(0)) {  
61                availableCars[counter] = i;  
62                counter++;  
63            }  
64        }  
65        return availableCars;  
66    }  
67  
68    // Get the owner and current borrower (if any) of a car  
69    function getCarInfo(uint256 tokenId)  
70        external  
71        view  
72        returns (  
73            address owner,  
74            address borrower,  
75            uint256 borrowedTime,  
76            uint256 borrowedTimeDuration  
77        )  
78    {  
79        require(exists(tokenId), "CarNFT: Car does not exist");  
80        Car storage car = _cars[tokenId];  
81        return (  
82            car.owner,  
83            car.borrower,  
84            car.borrowedTime,  
85            car.borrowedTimeDuration  
86        );  
87    }  
88  
89    // Borrow a car  
90    function borrowCar(uint256 tokenId, uint256 wantBorrowTimeDuration) public {  
91        require(exists(tokenId), "CarNFT: Car does not exist");  
92        require(  
93            _cars[tokenId].borrower == address(0),  
94            "CarNFT: Car is already borrowed"  
95        );  
96        require(  
97            _cars[tokenId].owner != msg.sender,  
98            "CarNFT: You are the owner of the car"  
99        );  
100        uint256 amount = wantBorrowTimeDuration;  
101        require(  
102            myERC20.balanceOf(msg.sender) >= amount,  
103            "CarNFT: Insufficient token balance"  
104        );  
105  
106        _cars[tokenId].borrower = msg.sender;  
107        _cars[tokenId].borrowedTime = block.timestamp;  
108        _cars[tokenId].borrowedTimeDuration = wantBorrowTimeDuration;  
109  
110        myERC20.transferFrom(msg.sender, address(this), amount);  
111    }  
112  
113    // Return a car and pay the rental fee using tokens  
114    function returnCar(uint256 tokenId) public {  
115        require(exists(tokenId), "CarNFT: Car does not exist");  
116        require(  
117            _cars[tokenId].borrower == msg.sender,  
118            "CarNFT: You are not the borrower of this car"  
119        );  
120  
121        uint256 factBorrowTime = block.timestamp - _cars[tokenId].borrowedTime;  
122        if (factBorrowTime < _cars[tokenId].borrowedTimeDuration) {  
123            uint256 amount =  
124                _cars[tokenId].borrowedTimeDuration - factBorrowTime;  
125            myERC20.transfer(msg.sender, amount);  
126        } else if (factBorrowTime > _cars[tokenId].borrowedTimeDuration) {  
127            uint256 amount = factBorrowTime - _cars[tokenId].borrowedTimeDuration;  
128            myERC20.transferFrom(msg.sender, address(this), amount);  
129        }  
130  
131        myERC20.transfer(_cars[tokenId].owner, factBorrowTime);  
132        _cars[tokenId].borrower = address(0);  
133        _cars[tokenId].borrowedTime = 0;  
134        _cars[tokenId].borrowedTimeDuration = 0;  
135    }  
136}  