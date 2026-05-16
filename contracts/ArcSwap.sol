// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract ARCSwap {
    IERC721 public nftContract;
    uint256 public swapAmount = 1 ether; // Correspond à 1 USDC natif (18 décimales)

    // L'adresse de ton contrat NFT ARC Mega Winner
    constructor(address _nftAddress) {
        nftContract = IERC721(_nftAddress);
    }

    // Cette ligne magique permet au contrat de recevoir tes USDC pour faire sa trésorerie
    receive() external payable {}

    function swapNFTForUSDC(uint256 tokenId) external {
        // 1. Le contrat prend ton NFT et l'envoie à l'adresse morte (Burn)
        nftContract.transferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, tokenId);
        
        // 2. Sécurité : On vérifie que le contrat a bien de l'argent en réserve
        require(address(this).balance >= swapAmount, "Erreur : La tresorerie du casino est vide !");
        
        // 3. Le contrat envoie 1 USDC (natif) sur le portefeuille du joueur
        (bool success, ) = msg.sender.call{value: swapAmount}("");
        require(success, "Erreur lors de l'envoi de l'USDC");
    }
}
