Title: Try-Catch in AWS Step Functions
Date: 2021-04-22 17:00
Category: AWS
Tags: Step Functions, Serverless
Authors: Thomas Taylor
Description: How to apply a try/catch to multiple states in an AWS Step Function.

AWS Step Functions provide `Retry` and `Catch` [fields](https://states-language.net/spec.html#errors) to handle errors for individual tasks; however, what if you want to apply a try-catch pattern to several states at once? 

Does AWS provide this functionality? **Kinda**.

A try/catch block, in a development language, assumes that all the execution steps can be "grouped" under a try clause:

```javascript
try {
    taskOne();
    taskTwo();
    taskThree();
} catch ('States.ALL') {
    alertFailure();
    throw new Error();
}
notifySuccess()
```

In Step Functions, tasks can be grouped using a [parallel state](https://states-language.net/spec.html#parallel-state) branch. 

Following that logic, we can nest the tasks under a branch:
```json
{
  "StartAt": "Try",
  "States": {
        "Try": {
            "Type": "Parallel",
            "Branches": [
                {
                    "StartAt": "TaskOne",
                    "States": {
                        "TaskOne": {
                            "Type": "Pass",
                            "Next": "TaskTwo"
                        },
                        "TaskTwo": {
                            "Type": "Pass",
                            "Next": "TaskThree"
                        },
                        "TaskThree": {
                            "Type": "Pass",
                            "End": true
                        }
                    }
                }
            ],
            "Catch": [
                {
                    "ErrorEquals": [ "States.ALL" ],
                    "Next": "AlertFailure"
                }
            ],
            "Next": "NotifySuccess"
        },
        "AlertFailure": {
            "Type": "Pass",
            "Next": "Fail"
        },
        "Fail": {
            "Type": "Fail"
        },
        "NotifySuccess": {
            "Type": "Pass",
            "End": true
        }
    }
}
```

..graphviz dot
digraph G {
  Start [shape=circle,style=filled,fillcolor=gold];
  End [shape=circle,style=filled,fillcolor=gold];
  node [shape=box,style="dashed,rounded",color=gray];
  subgraph cluster_try {
    style="filled,rounded,dashed";
    fillcolor=white;
    color=gray;
    TaskOne -> TaskTwo -> TaskThree;
    label = "Try";
  }
  Start -> TaskOne;
  TaskThree -> AlertFailure [headlabel="\"Catch\""];
  AlertFailure -> "Throw Error";
  TaskThree -> NotifySuccess
  "Throw Error" -> End;
  NotifySuccess -> End;
  End;
}

Additionally, there is one consideration: a parallel state encapsulates the branch outputs into an array. To extract the output, add another `Pass` state:

```json
"ExtractOutput": {
    "Type": "Pass",
    "InputPath": "$[0]",
    "Next": "NotifySuccess"
}
```

..graphviz dot
digraph G {
  Start [shape=circle,style=filled,fillcolor=gold];
  End [shape=circle,style=filled,fillcolor=gold];
  node [shape=box,style="dashed,rounded",color=gray];
  subgraph cluster_try {
    style="filled,rounded,dashed";
    fillcolor=white;
    color=gray;
    TaskOne -> TaskTwo -> TaskThree;
    label = "Try";
  }
  Start -> TaskOne;
  TaskThree -> AlertFailure [headlabel="\"Catch\""];
  AlertFailure -> "Throw Error";
  TaskThree -> ExtractOutput;
  ExtractOutput -> NotifySuccess;
  "Throw Error" -> End;
  NotifySuccess -> End;
  End;
}

**Final StepFunction**

```json
{
  "StartAt": "Try",
  "States": {
        "Try": {
            "Type": "Parallel",
            "Branches": [
                {
                    "StartAt": "TaskOne",
                    "States": {
                        "TaskOne": {
                            "Type": "Pass",
                            "Next": "TaskTwo"
                        },
                        "TaskTwo": {
                            "Type": "Pass",
                            "Next": "TaskThree"
                        },
                        "TaskThree": {
                            "Type": "Pass",
                            "End": true
                        }
                    }
                }
            ],
            "Catch": [
                {
                    "ErrorEquals": [ "States.ALL" ],
                    "Next": "AlertFailure"
                }
            ],
            "Next": "ExtractOutput"
        },
        "AlertFailure": {
            "Type": "Pass",
            "Next": "Fail"
        },
        "Fail": {
            "Type": "Fail"
        },
        "ExtractOutput": {
            "Type": "Pass",
            "InputPath": "$[0]",
            "Next": "NotifySuccess"
        },
        "NotifySuccess": {
            "Type": "Pass",
            "End": true
        }
    }
}
```