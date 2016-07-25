module Browsersync where
       -- ( defaultBSConfig
       -- , BSConfig
       -- , BROWSERSYNC
       -- ) where

import Prelude
import Control.Monad.Aff (makeAff, Aff)
import Control.Monad.Eff (Eff)

type BSEff e a = Eff (browsersync :: BROWSERSYNC | e) a

-- | A name for a Browsersync server instance
newtype Name = Name String

-- | Configuration for a Browsersync server instance
newtype BSConfig = BSConfig
  { ui :: { port :: Int}
  , server :: {baseDir :: String, directory :: Boolean}
  , port :: Int
  , open :: Boolean
  }

-- | A starting point for configuring a Browsersync server instance
defaultBSConfig :: BSConfig
defaultBSConfig = BSConfig
  { ui: { port: 8080}
  , server: {baseDir: "", directory: true}
  , port: 1337
  , open: false
  }

foreign import data BROWSERSYNC :: !
foreign import data BrowserSync :: *

foreign import create :: forall e. Name -> BSEff e BrowserSync
foreign import get    :: forall e. Name -> BSEff e BrowserSync
foreign import has    :: forall e. Name -> BSEff e Boolean
foreign import init   :: forall e. BrowserSync -> BSConfig -> (BSEff e Unit) -> BSEff e Unit
foreign import reload :: forall e. BrowserSync -> BSEff e Unit
foreign import notify :: forall e. BrowserSync -> String -> BSEff e Unit
foreign import exit   :: forall e. BrowserSync -> BSEff e Unit

-- | Checks whether an instance with the given `Name` exists and returns a
-- | handle to that instance in that case. If it doesn't creates a new server
-- | with the given configuration and returns a handle to that.
startServer
  :: forall e
   . Name
   -> BSConfig
   -> (BrowserSync -> BSEff e Unit)
   -> Eff (browsersync :: BROWSERSYNC | e) Unit
startServer name config k = do
  exists <- has name
  if exists
    then
      k =<< get name
    else do
      bs <- create name
      init bs config (k bs)

-- | Aff version of startServer
startServerAff
  :: forall e
  . Name
  -> BSConfig
  -> Aff (browsersync :: BROWSERSYNC | e) BrowserSync
startServerAff name conf =
  makeAff \_ k -> (startServer name conf k)
