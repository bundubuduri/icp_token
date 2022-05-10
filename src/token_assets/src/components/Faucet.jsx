import React, { useState } from "react";
import { token, canisterId, createActor } from "../../../declarations/token";
import {AuthClient} from "@dfinity/auth-client";

function Faucet() {

  const [isDisabled, setDisable] = useState(false);
  const [buttonText, setText] = useState("Gimme gimme");

  async function handleClick(event) {
    setDisable(true);

    const authClient = await AuthClient.create();
    const identity = await authClient.getIdentity();

    const authenticatdCanister = createActor(canisterId, {
      agentOptions:  {
        identity, 
      },
    });

    const result =  await authenticatdCanister.payOut();
    setText(result);
   // setDisable(false);

  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free formulaRoot tokens here! Claim 10,000 fR tokens to your account.</label>
      <p className="trade-buttons">
        <button id="btn-payout" 
        onClick={handleClick}
        disabled={isDisabled}
        >
          {buttonText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
