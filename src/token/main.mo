import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {
    let owner : Principal = Principal.fromText("grclp-j64sl-4jpr2-3fkoq-yez47-5mrtr-jtw45-5pa6l-jc6lb-cv6qx-zqe");
    let totalSupply : Nat = 1000000000;
    let symbol : Text = "fRoot";

    //create a temp variable of a stable type 
    private stable var balanceEntries: [(Principal, Nat)] = [];
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    if(balances.size() < 1 ) {
                balances.put(owner, totalSupply);
            };

    public query func balanceOf(who: Principal) : async Nat {

        let balance : Nat = switch (balances.get(who)){
            case null 0;
            case (?result) result;
        };
            
            return balance; 
    };


    public query func getSymbol() : async Text {
        
        return symbol;
    };

    public shared(msg) func payOut() : async Text {
       // Debug.print(debug_show(msg.caller));
    if (balances.get(msg.caller) == null) {
        let amount = 10000;
        let result = await transfer(msg.caller, amount);
        return result;
    } else {
        return "Already Claimed"
    }   

    };

    // We do not really have a "from" because whoever triggers this function is going to be the "from"
    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text {
        let fromBalance = await balanceOf(msg.caller);
        if (fromBalance > amount) {
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance = await  balanceOf(to);
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);

            return "Success"; 

        } else {
            return "Insufficient Tokens, Get some Tokens!!"
        }

    };

        
        //Upgrades to convert balance to become stable 

    system func preupgrade() {
        balanceEntries  :=  Iter.toArray(balances.entries());
        };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);
            if(balances.size() < 1 ) {
                balances.put(owner, totalSupply);
            }
        };


};

