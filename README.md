# Question Generator

This is a Rails application that can perform the following operation.

1. Given the required parameters, this application can generate a set of questions that satisfies the passed condition.
2. This is completely API only application.

## Instruction

The application is hosted https://questions-generator.herokuapp.com and has two endpoints.

1. The root endpoint that shows the loaded questions. Given the restriction to DB, the application loads a set of question from an YAML file located in https://github.com/Navdevl/questionGenerator/blob/master/lib/data/questions.yml 

2. POST call to https://questions-generator.herokuapp.com/questions/generate with a payload like the one given below can generate appropriate results.
`{"total": 100, "percentages": { "easy": 50, "medium": 25, "hard": 25 }}`

3. The total percentages should equal to 100% else there will be an error.

4. If the requirement can't be satisfied, it will also thrown an error.


