# Pre-work - *Tipster*

**Tipster** is a tip calculator application for iOS.

Submitted by: **Arun Gopinathan**

Time spent: **3** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [ ] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] User has the option to set custom tip

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/XMgFxj7.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** IBAction and IBOutlet are macros defined to denote variables and methods that can be referred to in Interface Builder. IBAction resolves to void and IBOutlet resolves to nothing, but they signify to Xcode and Interface builder that these variables and methods can be used in Interface builder to link UI elements to your code. Under the hood it is implemented as **XML**


Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** If a property of a class has a strong reference to a closure while the closure strongly captures *self* within its body, will result in a strong reference cycle. Even when the class reference is set to nil, the closure still holds *self* thereby both are not deallocated. Using a **Capture list** is one way of avoiding this issue. 


## License

    Copyright [2017] [Arun Gopinathan]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
