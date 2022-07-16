# WORK IN PROGRESS
# counter-analysis
In search of a cost-effective counter on EVM (Polygon / Arbitrum Nova).

**This repo & analysis assumes that counts are incrementing per user over a set period of time**

i.e. "the count of a player's wins per month"

# TLDR:

```
<pending results>
```

**Medium-form analysis:**

# Introduction

It's well known that [OpenZeppelin's Counters library](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol) gets clowned on quite frequently. In most cases, an off-chain solution such as a traditional DB or indexing on-chain data is sufficient. For example, you can index events or transaction calls to determine shares of an airdrop. However, there are some interesting cases where you may want an on-chain count. In DeFi, you may want to unlock functionality (tokens, discounted rates, etc) after a user has made *N* actions. In GameFi, maybe you want to track some event (i.e. "wins") and have token rewards as a function of the leaderboard.

In my particular use-case, the UX is nuanced and I can't have users pay for incrementing the counter. I will be the payer, and it will be an operational cost to the system. My initial worst-case-napkin-math estimate was 20,000 increments per day. Rounding up transaction fees on Polygon, to $0.001 per transaction, gives us a cost of $20 a day or $600 a month. That's digestible but is outside my cost-tolerance for a system that runs on extremely thin margins.

So, I went down the rabbit hole *how can I find an extremely cost efficient method for managing an on-chain counter*.

## On-chain vs. Off-chain

*"But saucepoint, for a few bucks a month you can run SQLite on AWS EFS that's attached to an AWS Lambda which handles the counter"*

Yep you're right, at 10,000s increments per day, I am most likely going to have an off-chain solution unless some god-tier, comically cheap EVM chain launches in the coming months. But that isn't stopping me from doing a lil' research and exploration.

My obsession over an on-chain counter is mostly rooted in *trustlessness*. For my use case, monetary rewards are a function of the counter. If the counter sits behind a centralized service, there is a substantial assumption that the opensource codebase is indeed being utilized in a fraud-free manner.

# Implementation of different counters

This repo & analysis assumes that counts are occuring over a period of time. For example, we want a count of actions *per month per user*. In this case, counts are referenced by `epoch` and `entity`. Here, `entity` represents an arbitrary actor such as an address, a user's account, a player (in the context of a game "save"), etc.


## Double-map

A counter represented as a double-map

```
// maps epoch => user => counter
mapping(uint256 => mapping(uint256 => uint256))

// example JSON representation
{
    ...
    // at epoch 100, user 10 had a count of 50 and user 20 had a count of 75
    100: {10: 50, 20: 75},  
    ...
}
```

## Mapped Array

A counter represented as a mapping to an array.

The index of the array corresponds to a user's id
```
// maps epoch => counts[]
mapping(uint256 => uint256[])

// example JSON representation
{
    ...
    // at epoch 100, user 0 had a count of 50 and user 1 had a count of 75
    100: [50, 75],
    ...
}
```

## Dense Array

A counter represented as a 2-dimensional array.

The first index is the epoch, and the second index is the user's id

```
uint256[][] denseArray;

// example JSON representation
[
    // at epoch 0, user 0 had a count of 50 and user 1 had a count of 75
    [50, 75],
    ...
]
```

## Event Counter

A counter represented by a Contract event.

This is an interesting mechanism for counting, since summation of events occurs off-chain. But having an on-chain event enables auditability and accountability of the system. Users will be able to confirm 1) their actions have a corresponding on-chain event and 2) summation of events is accurate.

```
event CountEvent(uint256 epoch, uint256 userId);

// emitting the event represents an increment
// a client will be responsible for tallying the events
// at epoch 100, user 1 had their count incremented
emit CountEvent(100, 1);
```
