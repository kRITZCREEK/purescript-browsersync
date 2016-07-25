module Test.Browsersync where

import Prelude
import Test.Unit.Assert as Assert
import Browsersync (has, BROWSERSYNC, Name(Name), exit, defaultBSConfig, startServerAff)
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import Test.Unit (TIMER, test, suite)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTest)

main :: forall e. Eff ( avar :: AVAR
                      , browsersync :: BROWSERSYNC
                      , console :: CONSOLE
                      , testOutput :: TESTOUTPUT
                      , timer :: TIMER
                      | e) Unit
main = runTest do
  suite "sync code" do
    test "Browsersync" do
      let name = Name "testServer"
      server <- startServerAff name defaultBSConfig
      b <- liftEff (has name)
      liftEff (exit server)
      b' <- liftEff (has name)
      Assert.assert "Should be running" b
      Assert.assert "Should not be running" b'
