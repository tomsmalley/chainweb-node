{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

-- |
-- Module: Chainweb.Payload.RestAPI.Client
-- Copyright: Copyright © 2019 Kadena LLC.
-- License: MIT
-- Maintainer: Lars Kuhtz <lars@kadena.io>
-- Stability: experimental
--
-- TODO
--
module Chainweb.Payload.RestAPI.Client
( payloadClient
, outputsClient
) where

import Control.Monad.Identity

import Data.Proxy

import Servant.Client

-- internal modules

import Chainweb.BlockHeader
import Chainweb.ChainId
import Chainweb.Payload
import Chainweb.Payload.RestAPI
import Chainweb.RestAPI.Orphans ()
import Chainweb.Version

-- -------------------------------------------------------------------------- --
-- GET Payload Client

payloadClient_
    :: forall (v :: ChainwebVersionT) (c :: ChainIdT)
    . KnownChainwebVersionSymbol v
    => KnownChainIdSymbol c
    => BlockPayloadHash
    -> ClientM PayloadData
payloadClient_ = client (payloadGetApi @v @c)

payloadClient
    :: ChainwebVersion
    -> ChainId
    -> BlockPayloadHash
    -> ClientM PayloadData
payloadClient v c k = runIdentity $ do
    SomeChainwebVersionT (_ :: Proxy v) <- return $ someChainwebVersionVal v
    SomeChainIdT (_ :: Proxy c) <- return $ someChainIdVal c
    return $ payloadClient_ @v @c k

-- -------------------------------------------------------------------------- --
-- GET Outputs Client

outputsClient_
    :: forall (v :: ChainwebVersionT) (c :: ChainIdT)
    . KnownChainwebVersionSymbol v
    => KnownChainIdSymbol c
    => BlockPayloadHash
    -> ClientM PayloadWithOutputs
outputsClient_ = client (outputsGetApi @v @c)

outputsClient
    :: ChainwebVersion
    -> ChainId
    -> BlockPayloadHash
    -> ClientM PayloadWithOutputs
outputsClient v c k = runIdentity $ do
    SomeChainwebVersionT (_ :: Proxy v) <- return $ someChainwebVersionVal v
    SomeChainIdT (_ :: Proxy c) <- return $ someChainIdVal c
    return $ outputsClient_ @v @c k


