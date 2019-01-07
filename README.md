# Resident Match
Implementing the [Resident Matching algorithm](https://en.wikipedia.org/wiki/National_Resident_Matching_Program#Matching_algorithm)

[![CircleCI](https://circleci.com/gh/jcobian/resident_matching.svg?style=svg)](https://circleci.com/gh/jcobian/resident_matching)

## Usage

### Run the match
This will create fake data on the fly, run the match, and print a summary of the results
```bash
ruby match.rb
```

## Tests
```
rspec
```

## Algorithm
Borrowed and tweaked from the [stable marriage problem](https://en.wikipedia.org/wiki/Stable_marriage_problem#Algorithm)

## Disclaimer
I take no credit for the algorithm. This is meant as a learning exercise and free for anyone to use and modify.
