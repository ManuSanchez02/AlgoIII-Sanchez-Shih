!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:48'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'first'.
	secondPushedObject := 'second'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'testing - private' stamp: 'MS 5/15/2022 14:24:31'!
addElementsFrom: anOrderedCollection to: aStack

	anOrderedCollection do: [:anElement | aStack push: anElement ].! !

!SentenceFinderByPrefixTest methodsFor: 'testing - private' stamp: 'IS 5/12/2022 20:57:45'!
assertStack: aStack orderIsEqualTo: anOrderedCollection

	self assert: aStack size equals: anOrderedCollection size.

	self shouldBeImplemented.! !


!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'IS 5/12/2022 20:27:37'!
test01FindingEmptyPrefixInSentenceFinderReturnsEmptyPrefixError
	
	| sentenceFinderByPrefix stack |
	
	stack := OOStack new.
	
	sentenceFinderByPrefix := SentenceFinderByPrefix with: stack.
	
	self
		should: [ sentenceFinderByPrefix find: '' ]
		raise:  Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix prefixCannotBeEmptyError ]! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'IS 5/12/2022 20:29:48'!
test02FindingPrefixWithSpacesInSentenceFinderReturnsPrefixCannotIncludeEmptySpacesError
	
	| sentenceFinderByPrefix stack |
	
	stack := OOStack new.
	
	stack push: 'hola mundo'.
	
	sentenceFinderByPrefix := SentenceFinderByPrefix with: stack.
	
	self
		should: [ sentenceFinderByPrefix find: 'hola mundo' ]
		raise:  Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix prefixCannotIncludeEmptySpacesError ]! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'IS 5/12/2022 20:29:03'!
test03findingAPrefixOnEmptyStackReturnsEmptyCollection
	
	| sentenceFinderByPrefix stack |
	
	stack := OOStack new.
	
	sentenceFinderByPrefix := SentenceFinderByPrefix with: stack.

	
	self assert: (	(sentenceFinderByPrefix find: 'hola') size = 0).! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'IS 5/12/2022 20:29:09'!
test04findingPrefixWintOnNonEmptyStackReturnsWinterIsHere
	
	| sentenceFinderByPrefix stack winterIsHereCollection |
	
	stack := OOStack new.
	
	stack push: 'winter is coming'.
	stack push: 'winning is everything'.
	stack push: 'The winds of Winter'.
	stack push: 'Winter is here'.
	
	sentenceFinderByPrefix := SentenceFinderByPrefix with: stack.
	
	winterIsHereCollection := OrderedCollection new.
	winterIsHereCollection add: 'Winter is here'.
	
	
	self assert: (	(sentenceFinderByPrefix find: 'Wint')) equals: winterIsHereCollection.! !

!SentenceFinderByPrefixTest methodsFor: 'testing' stamp: 'MS 5/15/2022 14:26:27'!
test05findingAPrefixWithMultipleMatchesOnNonEmptyStackReturnsTheMatches
	
	| sentenceFinderByPrefix stack expectedCollection correctOrderCollection |
	
	stack := OOStack new.
	sentenceFinderByPrefix := SentenceFinderByPrefix with: stack.
	expectedCollection := OrderedCollection new.
	correctOrderCollection := OrderedCollection new.
	
	expectedCollection addAll: #('Winter is not here' 'Winter is here' 'Windows XP').
	correctOrderCollection addAll: #('winter is coming' 'winning is everything' 'Windows XP' 'The winds of Winter' 'Winter is here' 'Winter is not here').
	
	self addElementsFrom: correctOrderCollection to: stack.
		
	self assert: (sentenceFinderByPrefix find: 'Win') equals: expectedCollection.
	self assert: (self stackOrderOf: stack isEqualTo: correctOrderCollection ).
! !


!SentenceFinderByPrefixTest methodsFor: 'as yet unclassified' stamp: 'MS 5/15/2022 14:38:02'!
stackOrderOf: aStack isEqualTo: anOrderedCollection 
	| reversedStack |
	
	reversedStack := OOStack new.
	
	[ aStack isEmpty not ] whileTrue: [
		| currentElement |
		
		currentElement := aStack pop.
		
		reversedStack push: currentElement.	
	]! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'elementsInStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'adding' stamp: 'MS 5/11/2022 23:38:29'!
push: aString 

	elementsInStack addFirst: aString.! !


!OOStack methodsFor: 'private' stamp: 'MS 5/12/2022 00:14:26'!
emptyStackError

	^self error: self class stackEmptyErrorDescription.! !

!OOStack methodsFor: 'private' stamp: 'MS 5/11/2022 23:37:12'!
notEmptyStackPop

	^elementsInStack removeFirst.! !

!OOStack methodsFor: 'private' stamp: 'MS 5/11/2022 23:30:03'!
notEmptyStackTop

	^elementsInStack first.! !


!OOStack methodsFor: 'accessing' stamp: 'MS 5/12/2022 00:10:55'!
currentState

	| subclasses currentState |

	subclasses := OOStackState subclasses.
	
	currentState := subclasses detect: [ :aState | aState validStateFor: self isEmpty. ].

	^currentState new.! !

!OOStack methodsFor: 'accessing' stamp: 'MS 5/11/2022 22:31:49'!
isEmpty
	
	^self size = 0.! !

!OOStack methodsFor: 'accessing' stamp: 'MS 5/11/2022 23:38:35'!
size

	^elementsInStack size.! !

!OOStack methodsFor: 'accessing' stamp: 'MS 5/11/2022 23:27:31'!
top

	^self currentState top: self.! !


!OOStack methodsFor: 'removing' stamp: 'MS 5/11/2022 23:36:09'!
pop

	^self currentState pop: self.! !


!OOStack methodsFor: 'initializing' stamp: 'MS 5/11/2022 23:38:21'!
initialize

	elementsInStack  := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: 'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 5/7/2012 11:51'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !


!classDefinition: #OOStackState category: 'Stack-Exercise'!
Object subclass: #OOStackState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackState methodsFor: 'public' stamp: 'MS 5/11/2022 23:41:21'!
pop: anOOStack
	self subclassResponsibility.! !

!OOStackState methodsFor: 'public' stamp: 'MS 5/11/2022 23:41:25'!
top: anOOStack
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackState class' category: 'Stack-Exercise'!
OOStackState class
	instanceVariableNames: ''!

!OOStackState class methodsFor: 'testing' stamp: 'MS 5/12/2022 00:16:36'!
validStateFor: aStackIsEmptyBoolean
	self subclassResponsibility.! !


!classDefinition: #OOStackEmptyState category: 'Stack-Exercise'!
OOStackState subclass: #OOStackEmptyState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackEmptyState methodsFor: 'public' stamp: 'MS 5/12/2022 00:14:36'!
pop: anOOStack
	
	^anOOStack emptyStackError. ! !

!OOStackEmptyState methodsFor: 'public' stamp: 'MS 5/12/2022 00:14:38'!
top: anOOStack
	
	^anOOStack emptyStackError. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackEmptyState class' category: 'Stack-Exercise'!
OOStackEmptyState class
	instanceVariableNames: ''!

!OOStackEmptyState class methodsFor: 'testing' stamp: 'MS 5/12/2022 00:12:44'!
validStateFor: aStackIsEmptyBoolean

	^aStackIsEmptyBoolean! !


!classDefinition: #OOStackNotEmptyState category: 'Stack-Exercise'!
OOStackState subclass: #OOStackNotEmptyState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackNotEmptyState methodsFor: 'public' stamp: 'MS 5/11/2022 23:36:30'!
pop: anOOStack

	^anOOStack notEmptyStackPop.! !

!OOStackNotEmptyState methodsFor: 'public' stamp: 'MS 5/11/2022 23:29:35'!
top: anOOStack

	^anOOStack notEmptyStackTop.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackNotEmptyState class' category: 'Stack-Exercise'!
OOStackNotEmptyState class
	instanceVariableNames: ''!

!OOStackNotEmptyState class methodsFor: 'testing' stamp: 'MS 5/12/2022 00:12:25'!
validStateFor: aStackIsEmptyBoolean

	^aStackIsEmptyBoolean not.! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: 'sentenceStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefix methodsFor: 'initialization' stamp: 'IS 5/12/2022 19:53:06'!
initializeWith: aSentenceStack

	sentenceStack := aSentenceStack.! !


!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'IS 5/12/2022 20:20:03'!
assertValidPrefix: aPrefix
	
	(aPrefix includes: $ ) ifTrue: [^self error: 	self class prefixCannotIncludeEmptySpacesError ].
	(aPrefix size = 0) ifTrue: [^self error: self class prefixCannotBeEmptyError ].
	! !

!SentenceFinderByPrefix methodsFor: 'as yet unclassified' stamp: 'IS 5/12/2022 20:20:25'!
find: aPrefix

	| auxiliaryStack aSentenceCollection |
	
	self assertValidPrefix: aPrefix.
	
	auxiliaryStack := OOStack new.
	aSentenceCollection := OrderedCollection new.
	
	[ sentenceStack isEmpty not ] whileTrue: [	 
		| sentence |
		sentence := sentenceStack pop.
		auxiliaryStack push: sentence.
		
		(sentence beginsWith: aPrefix) ifTrue: [ aSentenceCollection add: sentence ].		
	].

	[ auxiliaryStack isEmpty not ] whileTrue: [
		sentenceStack push: auxiliaryStack pop.
	].

	^aSentenceCollection ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'initialization' stamp: 'IS 5/12/2022 19:53:54'!
with: aSentenceStack

	^self new initializeWith: aSentenceStack.! !


!SentenceFinderByPrefix class methodsFor: 'error descriptions' stamp: 'IS 5/12/2022 20:18:58'!
prefixCannotBeEmptyError
	
	^'Prefix cannot be empty'! !

!SentenceFinderByPrefix class methodsFor: 'error descriptions' stamp: 'IS 5/12/2022 20:19:17'!
prefixCannotIncludeEmptySpacesError
	
	^'Prefix cannot include empty spaces'! !
