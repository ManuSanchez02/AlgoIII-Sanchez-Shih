!classDefinition: #CantSuspend category: 'CodigoRepetido-Ejercicio'!
Error subclass: #CantSuspend
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #NotFound category: 'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #CustomerBookTest category: 'CodigoRepetido-Ejercicio'!
TestCase subclass: #CustomerBookTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBookTest methodsFor: 'private-testing' stamp: 'IM 4/30/2022 17:31:56'!
addCustomer: aCustomer TakesLessThan: duration

	| customerBook millisecondsBeforeRunning millisecondsAfterRunning |
	
	customerBook := CustomerBook new.
	
	millisecondsBeforeRunning := Time millisecondClockValue * millisecond.
	customerBook addCustomerNamed: aCustomer.
	millisecondsAfterRunning := Time millisecondClockValue * millisecond.
	
	^(millisecondsAfterRunning-millisecondsBeforeRunning) < duration.
	
! !

!CustomerBookTest methodsFor: 'private-testing' stamp: 'IM 4/30/2022 17:17:20'!
addSuspendedCustomer: aCustomer to: aCustomerBook
	aCustomerBook addCustomerNamed: aCustomer.
	aCustomerBook suspendCustomerNamed: aCustomer.
	
	! !

!CustomerBookTest methodsFor: 'private-testing' stamp: 'IM 4/30/2022 17:30:16'!
verifyNumberOfActive: aNumberOfActiveCustomers Suspended: aNumberOfSuspendedCustomers Total: aNumberOfCustomers in: aCustomerBook
	^(aCustomerBook numberOfActiveCustomers = aNumberOfActiveCustomers) 
		and: [aCustomerBook numberOfSuspendedCustomers = aNumberOfSuspendedCustomers ] 
		and: [aCustomerBook numberOfCustomers = aNumberOfCustomers]! !

!CustomerBookTest methodsFor: 'private-testing' stamp: 'IM 4/30/2022 17:29:59'!
verifyNumberOfCustomers: aNumber CustomerName: aCustomer in: aCustomerBook
	^(aCustomerBook numberOfCustomers = aNumber) and: [aCustomerBook includesCustomerNamed: aCustomer].
! !


!CustomerBookTest methodsFor: 'testing' stamp: 'IM 4/30/2022 17:31:56'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds
	self assert: (self addCustomer: 'John Lennon' TakesLessThan: (50 * millisecond)).
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'IM 4/30/2022 17:31:56'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds
	self assert: (self addCustomer: 'Paul McCartney' TakesLessThan: (100 * millisecond)).
	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'HernanWilkinson 5/9/2012 18:12'!
test03CanNotAddACustomerWithEmptyName 

	| customerBook |
			
	customerBook := CustomerBook new.

	[ customerBook addCustomerNamed: ''.
	self fail ]
		on: Error 
		do: [ :anError | 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty ]! !

!CustomerBookTest methodsFor: 'testing' stamp: 'HAW 8/28/2017 08:57:25'!
test04CanNotRemoveAnInvalidCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	
	[ customerBook removeCustomerNamed: 'Paul McCartney'.
	self fail ]
		on: NotFound 
		do: [ :anError | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: johnLennon) ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'IM 4/30/2022 17:30:16'!
test05SuspendingACustomerShouldNotRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	self addSuspendedCustomer: paulMcCartney to: customerBook.
	
	self assert: (self verifyNumberOfActive: 0 Suspended: 1 Total: 1 in: customerBook).
	
	self assert: (customerBook includesCustomerNamed: paulMcCartney).
	

	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'IM 4/30/2022 17:30:16'!
test06RemovingASuspendedCustomerShouldRemoveItFromCustomerBook

	| customerBook paulMcCartney|
	
	customerBook := CustomerBook new.
	paulMcCartney := 'Paul McCartney'.
	
	self addSuspendedCustomer: paulMcCartney to: customerBook.
	customerBook removeCustomerNamed: paulMcCartney.
	
	self assert: (self verifyNumberOfActive: 0 Suspended: 0 Total: 0 in: customerBook).
		
	self deny: (customerBook includesCustomerNamed: paulMcCartney).


	
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'IM 4/30/2022 17:29:59'!
test07CanNotSuspendAnInvalidCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	customerBook addCustomerNamed: johnLennon.
	
	[ customerBook suspendCustomerNamed: 'Ringo Starr'.
	self fail ]
		on: CantSuspend 
		do: [ :anError | self assert: (self verifyNumberOfCustomers: 1 CustomerName: johnLennon in: customerBook) ]
! !

!CustomerBookTest methodsFor: 'testing' stamp: 'IM 4/30/2022 17:29:59'!
test08CanNotSuspendAnAlreadySuspendedCustomer
	
	| customerBook johnLennon |
			
	customerBook := CustomerBook new.
	johnLennon := 'John Lennon'.
	self addSuspendedCustomer: johnLennon to: customerBook.
	
	[ customerBook suspendCustomerNamed: johnLennon.
	self fail ]
		on: CantSuspend 
		do: [ :anError | self assert: (self verifyNumberOfCustomers: 1 CustomerName: johnLennon in: customerBook) ]
! !


!classDefinition: #CustomerBook category: 'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'suspended active'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
includesCustomerNamed: aName

	^(active includes: aName) or: [ suspended includes: aName ]! !

!CustomerBook methodsFor: 'testing' stamp: 'NR 4/3/2019 10:14:26'!
isEmpty
	
	^active isEmpty and: [ suspended isEmpty ]! !


!CustomerBook methodsFor: 'initialization' stamp: 'NR 4/3/2019 10:14:26'!
initialize

	super initialize.
	active := OrderedCollection new.
	suspended:= OrderedCollection new.! !


!CustomerBook methodsFor: 'customer management' stamp: 'MS 4/30/2022 16:09:36'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(self includesCustomerNamed: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	active add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 4/3/2019 10:14:26'!
numberOfActiveCustomers
	
	^active size! !

!CustomerBook methodsFor: 'customer management' stamp: 'MS 4/30/2022 16:11:43'!
numberOfCustomers
	
	^self numberOfActiveCustomers + self numberOfSuspendedCustomers! !

!CustomerBook methodsFor: 'customer management' stamp: 'NR 9/19/2018 17:36:09'!
numberOfSuspendedCustomers
	
	^suspended size! !

!CustomerBook methodsFor: 'customer management' stamp: 'MS 4/30/2022 17:01:05'!
removeCustomerNamed: aName 
 
	(self includesCustomerNamed: aName) ifTrue: [
		active remove: aName ifAbsent: [nil].
		suspended remove: aName ifAbsent: [nil].
		^aName.
	].
	
	^ NotFound signal.
! !

!CustomerBook methodsFor: 'customer management' stamp: 'MS 4/30/2022 16:52:34'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

!CustomerBook methodsFor: 'customer management' stamp: 'MS 4/30/2022 17:00:30'!
suspendCustomerNamed: aName 
	
	active remove: aName ifAbsent: [^CantSuspend signal]. 
	
	suspended add: aName
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: 'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/30/2020 09:05:18'!
customerAlreadyExistsErrorMessage

	^'Customer Already Exists'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'NR 4/30/2020 09:05:25'!
customerCanNotBeEmptyErrorMessage

	^'Customer Name Cannot Be Empty'! !
