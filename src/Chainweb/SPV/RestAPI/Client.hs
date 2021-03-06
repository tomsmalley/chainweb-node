{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

-- |
-- Module: Chainweb.SPV.RestAPI.Client
-- Copyright: Copyright © 2019 Kadena LLC.
-- License: MIT
-- Maintainer: Lars Kuhtz <lars@kadena.io>
-- Stability: experimental
--
-- TODO
--
module Chainweb.SPV.RestAPI.Client
( spvGetTransactionProofClient
, spvGetTransactionOutputProofClient
) where

import Control.Monad.Identity

import Crypto.Hash.Algorithms

import Data.Proxy

import Numeric.Natural

import Servant.Client

-- internal modules

import Chainweb.BlockHeader
import Chainweb.ChainId
import Chainweb.SPV
import Chainweb.SPV.RestAPI
import Chainweb.RestAPI.Orphans ()
import Chainweb.Version

-- -------------------------------------------------------------------------- --
-- SPV Transaction Proof Client

spvGetTransactionProofClient_
    :: forall (v :: ChainwebVersionT) (c :: ChainIdT)
    . KnownChainwebVersionSymbol v
    => KnownChainIdSymbol c
    => ChainId
        -- ^ the source chain of the proof. This is the chain where the proof
        -- subject, the transaction for which inclusion is proven, is located.
    -> BlockHeight
        -- ^ the block height of the proof subject, the transaction for which
        -- inclusion is proven.
    -> Natural
        -- ^ the index of the proof subject, the transaction for which inclusion
        -- is proven.
    -> ClientM (TransactionProof SHA512t_256)
spvGetTransactionProofClient_ = client (spvGetTransactionProofApi @v @c)

spvGetTransactionProofClient
    :: ChainwebVersion
    -> ChainId
        -- ^ the target chain of the proof. This is the chain for which
        -- inclusion is proved.
    -> ChainId
        -- ^ the source chain of the proof. This is the chain where the proof
        -- subject, the transaction for which inclusion is proven, is located.
    -> BlockHeight
        -- ^ the block height of the proof subject, the transaction for which
        -- inclusion is proven.
    -> Natural
        -- ^ the index of the proof subject, the transaction for which inclusion
        -- is proven.
    -> ClientM (TransactionProof SHA512t_256)
spvGetTransactionProofClient v tcid scid h i = runIdentity $ do
    SomeChainwebVersionT (_ :: Proxy v) <- return $ someChainwebVersionVal v
    SomeChainIdT (_ :: Proxy c) <- return $ someChainIdVal tcid
    return $ spvGetTransactionProofClient_ @v @c scid h i

-- -------------------------------------------------------------------------- --
-- SPV Transaction Output Proof Client

spvGetTransactionOutputProofClient_
    :: forall (v :: ChainwebVersionT) (c :: ChainIdT)
    . KnownChainwebVersionSymbol v
    => KnownChainIdSymbol c
    => ChainId
        -- ^ the source chain of the proof. This is the chain where the proof
        -- subject, the transaction  output for which inclusion is proven, is
        -- located.
    -> BlockHeight
        -- ^ the block height of the proof subject, the transaction output for
        -- which inclusion is proven.
    -> Natural
        -- ^ the index of the proof subject, the transaction output for which
        -- inclusion is proven.
    -> ClientM (TransactionOutputProof SHA512t_256)
spvGetTransactionOutputProofClient_ = client (spvGetTransactionOutputProofApi @v @c)

spvGetTransactionOutputProofClient
    :: ChainwebVersion
    -> ChainId
        -- ^ the target chain of the proof. This is the chain for which inclusion
        -- is proved.
    -> ChainId
        -- ^ the source chain of the proof. This is the chain where the proof
        -- subject, the transaction  output for which inclusion is proven, is
        -- located.
    -> BlockHeight
        -- ^ the block height of the proof subject, the transaction output for
        -- which inclusion is proven.
    -> Natural
        -- ^ the index of the proof subject, the transaction output for which
        -- inclusion is proven.
    -> ClientM (TransactionOutputProof SHA512t_256)
spvGetTransactionOutputProofClient v tcid scid h i = runIdentity $ do
    SomeChainwebVersionT (_ :: Proxy v) <- return $ someChainwebVersionVal v
    SomeChainIdT (_ :: Proxy c) <- return $ someChainIdVal tcid
    return $ spvGetTransactionOutputProofClient_ @v @c scid h i

