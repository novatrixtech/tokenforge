/*
SPDX-License-Identifier: no-license
*/
pragma solidity ^0.8.12;
import "./ERCGovernance.sol";
import "./openzeppelin/contracts/token/ERC721/ERC721.sol";


abstract contract ERC721URIStorage is ERC721 {
    using Strings for uint256;

    // Optional mapping for token URIs
    mapping (uint256 => string) private _tokenURIs;

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

contract TokenERC721 is ERC721URIStorage, ERCGovernance {
    constructor(string memory _name, string memory _symbol, address _owner) ERC721(_name, _symbol) ERCGovernance(_owner) {    }

    function addr() public view virtual returns(address) {
        return address(this);
    }    

    function mintAndSetURI(address _itemOwner, uint256 _id, string memory _tokenURI) public onlyOperator returns (bool){
        _mint(_itemOwner, _id);
        _setTokenURI(_id, _tokenURI);
        return true;
    }
    function changeTokenURI(string memory _tokenURI, uint256 _id) public onlyOwner returns(bool){
        _setTokenURI(_id, _tokenURI);
        return true;
    }

}
