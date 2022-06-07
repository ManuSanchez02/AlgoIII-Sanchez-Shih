!classDefinition: #PortfolioTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:03:01'!
test01EmptyPortfolioHasZeroBalance
	| portfolio |
	
	portfolio := Portfolio with: {}.
	
	
	self assert: 0*peso equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:03:12'!
test02PortfolioWithOneAccountHasSameBalanceAsAccount
	| portfolio anAccount |
	
	anAccount := ReceptiveAccount new.
	Deposit register: 100*peso on: anAccount.
	
	portfolio := Portfolio with: {anAccount}.
	
	
	self assert: anAccount balance equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:07:28'!
test03PortfolioWithMultipleAccountsHasSameBalanceAsSumOfAccountBalances
	| portfolio anAccount aSecondAccount aThirdAccount |
	
	anAccount := ReceptiveAccount new.
	aSecondAccount := ReceptiveAccount new.
	aThirdAccount := ReceptiveAccount new.
	Deposit register: 100*peso on: anAccount.
	Deposit register: 200*peso on: aSecondAccount.
	Deposit register: 130*peso on: aThirdAccount.
	
	portfolio := Portfolio with: {anAccount. aSecondAccount. aThirdAccount}.
	
	
	self assert: 430*peso equals: portfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:13:26'!
test04PortfolioWithAccountAndPortfolioHasSameBalanceAsSumOfAllAccountBalances
	| aPortfolio anotherPortfolio anAccount aSecondAccount aThirdAccount |
	
	anAccount := ReceptiveAccount new.
	aSecondAccount := ReceptiveAccount new.
	aThirdAccount := ReceptiveAccount new.
	Deposit register: 100*peso on: anAccount.
	Deposit register: 200*peso on: aSecondAccount.
	Deposit register: 130*peso on: aThirdAccount.
	
	aPortfolio := Portfolio with: {anAccount. aSecondAccount }.
	anotherPortfolio := Portfolio with: {aPortfolio. aThirdAccount}.
	
	self assert: 430*peso equals: anotherPortfolio balance.! !

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:22:17'!
test05PortfolioWithNoAccountsHasNoTransactionsRegistered

	| aPortfolio anAccount aDeposit |
	
	anAccount := ReceptiveAccount new.
	aPortfolio := Portfolio with: {}.
	aDeposit := Deposit register: 20*peso on: anAccount.
	
	self assert: false equals: (aPortfolio hasTransactionRegistered: aDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:23:14'!
test06PortfolioWithAccountThatHasTransactionHasItRegistered

	| aPortfolio anAccount aDeposit |
	
	anAccount := ReceptiveAccount new.
	aDeposit := Deposit register: 20*peso on: anAccount.
	aPortfolio := Portfolio with: {anAccount }.
	
	self assert: true equals: (aPortfolio hasTransactionRegistered: aDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:29:33'!
test07PortfolioWithOneAccountThatHasNoTransactionsHasNoTransactionsRegistered

	| aPortfolio anAccount aDeposit anotherAccount |
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	aDeposit := Deposit register: 20*peso on: anotherAccount.
	aPortfolio := Portfolio with: {anAccount}.
	
	self deny: (aPortfolio hasTransactionRegistered: aDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'IS 6/6/2022 21:31:02'!
test08PortfolioWithMultipleAccountsHasTransactionRegistered

	| aPortfolio anAccount aDeposit anotherAccount |
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	aDeposit := Deposit register: 20*peso on: anotherAccount.
	aPortfolio := Portfolio with: {anAccount. anotherAccount}.
	
	self assert: true equals: (aPortfolio hasTransactionRegistered: aDeposit).! !


!classDefinition: #ReceptiveAccountTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:43'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'MS 6/6/2022 12:59:49'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 * peso on: account.
		
	self assert: 100 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:14:24'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 * peso on: account.
	Withdraw register: 50 * peso on: account.
		
	self assert: 50 * peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:14'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50 * peso.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:10:22'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 * peso on: account.
	withdraw := Withdraw register: 50 * peso on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:12:14'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100 * peso.
	withdraw := Withdraw for: 50 * peso.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:12:23'!
test07AccountKnowsItsTransactions 

	| account deposit |
	
	account := ReceptiveAccount new.
	
	deposit := Deposit register: 50 * peso on: account.
		
	self assert: 1 equals: account transactions size.
	self assert: (account transactions includes: deposit).
! !


!classDefinition: #TransferTest category: 'ServiciosFinancieros-Ejercicio'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!


!TransferTest methodsFor: 'tests' stamp: 'IS 6/6/2022 20:43:19'!
test01TransferValueIsCorrect
	| extractionAccount depositAccount transfer |
	
	extractionAccount := ReceptiveAccount new.
	depositAccount := ReceptiveAccount new.
	
	transfer := Transfer register: 100*peso from: extractionAccount to: depositAccount.
	
	self assert: 100*peso equals: transfer value.
		
	! !

!TransferTest methodsFor: 'tests' stamp: 'IS 6/6/2022 20:43:23'!
test02TransferCanNotBeCreatedWithZeroValue
	| extractionAccount depositAccount |
	
	extractionAccount := ReceptiveAccount new.
	depositAccount := ReceptiveAccount new.
	
	self should: [Transfer register: 0*peso from: extractionAccount to: depositAccount.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | anError messageText = Transfer invalidValueTransferErrorDescription] 
		
		
	! !

!TransferTest methodsFor: 'tests' stamp: 'IS 6/6/2022 20:43:02'!
test03TransferCanNotBeCreatedWithNegativeValue
	| extractionAccount depositAccount |
	
	extractionAccount := ReceptiveAccount new.
	depositAccount := ReceptiveAccount new.
	
	self should: [Transfer register: -100*peso from: extractionAccount to: depositAccount.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | anError messageText = Transfer invalidValueTransferErrorDescription] 
		
		
	! !

!TransferTest methodsFor: 'tests' stamp: 'IS 6/6/2022 20:47:30'!
test04TransferCanNotBeBetweenTheSameAccounts
	| anAccount |
	
	anAccount := ReceptiveAccount new.
	
	self should: [Transfer register: 50*peso from: anAccount to: anAccount.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [:anError | anError messageText = Transfer invalidTransferAccountsErrorDescription ] 
		
		
	! !


!classDefinition: #AccountTransaction category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'MS 6/6/2022 12:43:58'!
beAddedTo: aBalance 
	self subclassResponsibility.! !

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'MS 6/6/2022 12:44:16'!
beAddedTo: aBalance 

	^aBalance + self value.! !

!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'ServiciosFinancieros-Ejercicio'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'ServiciosFinancieros-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'MS 6/6/2022 12:44:22'!
beAddedTo: aBalance 

	^aBalance - self value.! !

!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'ServiciosFinancieros-Ejercicio'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Portfolio category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Portfolio
	instanceVariableNames: 'arrayOfPortfoliosAndAccounts accounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Portfolio methodsFor: 'as yet unclassified' stamp: 'IS 6/6/2022 21:12:33'!
balance
	
	^accounts sum: [:anAccountOrPortfolio | anAccountOrPortfolio balance ] ifEmpty: [0*peso].! !

!Portfolio methodsFor: 'as yet unclassified' stamp: 'IS 6/6/2022 21:33:37'!
hasTransactionRegistered: aTransaction

	^accounts anySatisfy: [:anAccount | anAccount hasRegistered: aTransaction ].! !


!Portfolio methodsFor: 'initialization' stamp: 'IS 6/6/2022 20:56:43'!
initializeWith: anArrayOfPortfoliosAndAccounts 
	accounts := anArrayOfPortfoliosAndAccounts.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'ServiciosFinancieros-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'IS 6/6/2022 20:55:17'!
with: anArrayOfPortfoliosAndAccounts 
	^self new initializeWith: anArrayOfPortfoliosAndAccounts ! !


!classDefinition: #ReceptiveAccount category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'main protocol' stamp: 'MS 6/6/2022 12:42:39'!
balance
	| balance |
	balance := 0.

	transactions do: [ :aTransaction | 
		balance := aTransaction beAddedTo: balance. 
	].

	^balance.! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!classDefinition: #Transfer category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Transfer
	instanceVariableNames: 'value extractionAccount depositAccount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Transfer methodsFor: 'value' stamp: 'MS 6/6/2022 13:01:56'!
value
	^100*peso! !


!Transfer methodsFor: 'initialization' stamp: 'IS 6/6/2022 20:40:31'!
initializeRegister: aValue from: anExtractionAccount to: aDepositAccount 

! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'ServiciosFinancieros-Ejercicio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'IS 6/6/2022 20:49:00'!
assertAccount: anAccount isDifferentFrom: anotherAccount

	^ (anAccount = anotherAccount) ifTrue: [self error: self invalidTransferAccountsErrorDescription.]! !

!Transfer class methodsFor: 'instance creation' stamp: 'IS 6/6/2022 20:44:26'!
assertValueIsValid: aValue

	^ (aValue <= (0*peso)) ifTrue: [self error: self invalidValueTransferErrorDescription.]! !

!Transfer class methodsFor: 'instance creation' stamp: 'IS 6/6/2022 20:41:58'!
register: aValue from: anExtractionAccount to: aDepositAccount

	self assertValueIsValid: aValue.

	^self new initializeRegister: aValue from: anExtractionAccount to: aDepositAccount ! !


!Transfer class methodsFor: 'error handling' stamp: 'IS 6/6/2022 20:46:48'!
invalidTransferAccountsErrorDescription
	^'Extraction account and deposit account cant be the same account'.! !

!Transfer class methodsFor: 'error handling' stamp: 'IS 6/6/2022 20:27:22'!
invalidValueTransferErrorDescription
	^'Value cant be negative or zero'.! !
