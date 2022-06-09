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

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:17:09'!
test05PortfolioWithNoAccountsHasNoTransactionsRegistered

	| aPortfolio anAccount aDeposit |
	
	anAccount := ReceptiveAccount new.
	aPortfolio := Portfolio with: {}.
	aDeposit := Deposit register: 20*peso on: anAccount.
	
	self assert: false equals: (aPortfolio hasRegistered: aDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:17:09'!
test06PortfolioWithAccountThatHasTransactionHasItRegistered

	| aPortfolio anAccount aDeposit |
	
	anAccount := ReceptiveAccount new.
	aDeposit := Deposit register: 20*peso on: anAccount.
	aPortfolio := Portfolio with: {anAccount }.
	
	self assert: true equals: (aPortfolio hasRegistered: aDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:17:09'!
test07PortfolioWithOneAccountThatHasNoTransactionsHasNoTransactionsRegistered

	| aPortfolio anAccount aDeposit anotherAccount |
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	aDeposit := Deposit register: 20*peso on: anotherAccount.
	aPortfolio := Portfolio with: {anAccount}.
	
	self deny: (aPortfolio hasRegistered: aDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:17:09'!
test08PortfolioWithMultipleAccountsHasTransactionRegistered

	| aPortfolio anAccount aDeposit anotherAccount |
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	aDeposit := Deposit register: 20*peso on: anotherAccount.
	aPortfolio := Portfolio with: {anAccount. anotherAccount}.
	
	self assert: true equals: (aPortfolio hasRegistered: aDeposit).! !

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:13:12'!
test09EmptyPortfolioHasNoTransactions

	| aPortfolio |
	
	aPortfolio := Portfolio with: {}.
	
	self assert: aPortfolio transactions isEmpty.! !

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:13:31'!
test10PortfolioWithOneAccountHasItsTransactions

	| aPortfolio anAccount |
	
	anAccount := ReceptiveAccount new.
	Deposit register: 20*peso on: anAccount.
	aPortfolio := Portfolio with: {anAccount.}.
	
	self assert: anAccount transactions equals: (aPortfolio transactions)! !

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:14:31'!
test11PortfolioWithMultipleAccountsHasItsTransactions

	| aPortfolio anotherPortfolio anAccount anotherAccount transactions |
	
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	anotherPortfolio := Portfolio with: {anotherAccount}.
	transactions := OrderedCollection new.
	
	transactions addAll: {Deposit register: 20*peso on: anAccount. Deposit register: 40*peso on: anotherAccount. Withdraw register: 25*peso on: anotherAccount.}.

	aPortfolio := Portfolio with: {anAccount. anotherPortfolio}.
	
	self assert: transactions equals: (aPortfolio transactions)! !

!PortfolioTest methodsFor: 'tests' stamp: 'MS 6/8/2022 23:55:23'!
test12PortfolioCanNotBeCreatedWithRepeatedAccount

	| anAccount  |
	
	anAccount := ReceptiveAccount new.
	self should: [Portfolio with: {anAccount. anAccount}] 
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [:anError | anError messageText = Portfolio invalidAccountErrorDescription ].
	! !


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

!TransferTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:39:19'!
test05TransferDepositsMoneyOnDepositAccount
	| anExtractionAccount aDepositAccount transferencia |
	
	anExtractionAccount := ReceptiveAccount new.
	aDepositAccount := ReceptiveAccount new.
	
	transferencia := Transfer register: 150*peso from: anExtractionAccount to: aDepositAccount.
	
	self assert: transferencia value equals: aDepositAccount balance.! !

!TransferTest methodsFor: 'tests' stamp: 'MS 6/8/2022 22:39:30'!
test06TransferWithdrawsMoneyFromExtractionAccount
	| anExtractionAccount aDepositAccount transferencia |
	
	anExtractionAccount := ReceptiveAccount new.
	aDepositAccount := ReceptiveAccount new.
	
	transferencia := Transfer register: 20*peso from: anExtractionAccount to: aDepositAccount.
	
	self assert: transferencia value negated equals: anExtractionAccount balance.! !

!TransferTest methodsFor: 'tests' stamp: 'MS 6/8/2022 23:40:19'!
test07TransferWithdrawLegKnowsItsCounterpart
	| anExtractionAccount aDepositAccount transferencia |
	
	anExtractionAccount := ReceptiveAccount new.
	aDepositAccount := ReceptiveAccount new.
	
	transferencia := Transfer register: 50*peso from: anExtractionAccount to: aDepositAccount.
	
	self assert: transferencia depositLeg equals: transferencia withdrawLeg counterpart.! !

!TransferTest methodsFor: 'tests' stamp: 'MS 6/8/2022 23:40:37'!
test08TransferDepositLegKnowsItsCounterpart
	| anExtractionAccount aDepositAccount transferencia |
	
	anExtractionAccount := ReceptiveAccount new.
	aDepositAccount := ReceptiveAccount new.
	
	transferencia := Transfer register: 75*peso from: anExtractionAccount to: aDepositAccount.
	
	self assert: transferencia withdrawLeg equals: transferencia depositLeg counterpart.! !


!classDefinition: #Account category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Account methodsFor: 'main protocol' stamp: 'MS 6/8/2022 22:17:43'!
balance
	self subclassResponsibility.! !

!Account methodsFor: 'main protocol' stamp: 'MS 6/8/2022 22:17:53'!
hasRegistered: aTransaction
	self subclassResponsibility.! !

!Account methodsFor: 'main protocol' stamp: 'MS 6/8/2022 22:18:03'!
transactions
	self subclassResponsibility.! !


!classDefinition: #Portfolio category: 'ServiciosFinancieros-Ejercicio'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Portfolio methodsFor: 'main protocol' stamp: 'IS 6/6/2022 21:12:33'!
balance
	
	^accounts sum: [:anAccountOrPortfolio | anAccountOrPortfolio balance ] ifEmpty: [0*peso].! !

!Portfolio methodsFor: 'main protocol' stamp: 'MS 6/8/2022 22:17:09'!
hasRegistered: aTransaction

	^accounts anySatisfy: [:anAccount | anAccount hasRegistered: aTransaction ].! !

!Portfolio methodsFor: 'main protocol' stamp: 'MS 6/8/2022 22:05:42'!
transactions
	| transactions |

	transactions := OrderedCollection new.
	accounts do: [:anAccount | transactions addAll: anAccount transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'initialization' stamp: 'MS 6/8/2022 22:16:12'!
initializeWith: anArrayOfAccounts 
	accounts := anArrayOfAccounts.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'ServiciosFinancieros-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'error handling' stamp: 'MS 6/9/2022 00:04:34'!
invalidAccountErrorDescription
	^'Invalid account/s'! !


!Portfolio class methodsFor: 'instance creation' stamp: 'MS 6/9/2022 00:46:24'!
with: anArrayOfAccounts 

	^self new initializeWith: anArrayOfAccounts ! !


!classDefinition: #ReceptiveAccount category: 'ServiciosFinancieros-Ejercicio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'main protocol' stamp: 'MS 6/8/2022 23:38:04'!
balance
	^transactions inject: 0*peso into: [:aBalance :aTransaction | aTransaction beAddedTo: aBalance. ] 

! !

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


!classDefinition: #Transfer category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #Transfer
	instanceVariableNames: 'value deposit withdraw depositLeg withdrawLeg'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!Transfer methodsFor: 'initialization' stamp: 'MS 6/8/2022 23:28:03'!
initializeRegister: aValue from: anExtractionAccount to: aDepositAccount 
	
	value := aValue.
	
	withdrawLeg := TransferWithdraw register: aValue on: anExtractionAccount in: self.
	depositLeg := TransferDeposit register: aValue on: aDepositAccount in: self.! !


!Transfer methodsFor: 'accessing' stamp: 'MS 6/8/2022 23:10:37'!
depositLeg
	^depositLeg.! !

!Transfer methodsFor: 'accessing' stamp: 'MS 6/8/2022 22:37:51'!
value
	^value! !

!Transfer methodsFor: 'accessing' stamp: 'MS 6/8/2022 23:17:36'!
withdrawLeg
	^withdrawLeg.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'ServiciosFinancieros-Ejercicio'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'asserting' stamp: 'MS 6/8/2022 22:22:15'!
assertAccount: anAccount isDifferentFrom: anotherAccount

	^ (anAccount == anotherAccount) ifTrue: [self error: self invalidTransferAccountsErrorDescription.]! !

!Transfer class methodsFor: 'asserting' stamp: 'IS 6/6/2022 20:44:26'!
assertValueIsValid: aValue

	^ (aValue <= (0*peso)) ifTrue: [self error: self invalidValueTransferErrorDescription.]! !


!Transfer class methodsFor: 'instance creation' stamp: 'MS 6/8/2022 22:22:29'!
register: aValue from: anExtractionAccount to: aDepositAccount

	self assertValueIsValid: aValue.
	self assertAccount: anExtractionAccount isDifferentFrom: aDepositAccount.

	^self new initializeRegister: aValue from: anExtractionAccount to: aDepositAccount ! !


!Transfer class methodsFor: 'error handling' stamp: 'IS 6/6/2022 20:46:48'!
invalidTransferAccountsErrorDescription
	^'Extraction account and deposit account cant be the same account'.! !

!Transfer class methodsFor: 'error handling' stamp: 'IS 6/6/2022 20:27:22'!
invalidValueTransferErrorDescription
	^'Value cant be negative or zero'.! !


!classDefinition: #TransferTransaction category: 'ServiciosFinancieros-Ejercicio'!
Object subclass: #TransferTransaction
	instanceVariableNames: 'transfer value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferTransaction methodsFor: 'initialization' stamp: 'MS 6/8/2022 23:32:17'!
initializeFor: aValue in: aTransfer

	transfer := aTransfer.
	value := aValue.! !


!TransferTransaction methodsFor: 'main protocol' stamp: 'MS 6/8/2022 23:42:53'!
counterpart
	self subclassResponsibility.! !


!TransferTransaction methodsFor: 'value' stamp: 'MS 6/8/2022 23:29:03'!
beAddedTo: aBalance
	self subclassResponsibility.! !

!TransferTransaction methodsFor: 'value' stamp: 'MS 6/8/2022 23:39:49'!
value
	^value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferTransaction class' category: 'ServiciosFinancieros-Ejercicio'!
TransferTransaction class
	instanceVariableNames: ''!

!TransferTransaction class methodsFor: 'instance creation' stamp: 'MS 6/8/2022 23:43:10'!
for: aValue in: aTransfer

	self subclassResponsibility.! !

!TransferTransaction class methodsFor: 'instance creation' stamp: 'MS 6/8/2022 23:27:03'!
register: aValue on: account in: aTransfer

	| transaction |
	
	transaction := self for: aValue in: aTransfer.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #TransferDeposit category: 'ServiciosFinancieros-Ejercicio'!
TransferTransaction subclass: #TransferDeposit
	instanceVariableNames: 'counterpart'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferDeposit methodsFor: 'main protocol' stamp: 'MS 6/8/2022 23:41:39'!
counterpart
	^transfer withdrawLeg.! !


!TransferDeposit methodsFor: 'value' stamp: 'MS 6/8/2022 23:30:43'!
beAddedTo: aBalance

	^aBalance + self value.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferDeposit class' category: 'ServiciosFinancieros-Ejercicio'!
TransferDeposit class
	instanceVariableNames: ''!

!TransferDeposit class methodsFor: 'instance creation' stamp: 'MS 6/8/2022 23:27:21'!
for: aValue in: aTransfer

	^ self new initializeFor: aValue in: aTransfer. ! !


!classDefinition: #TransferWithdraw category: 'ServiciosFinancieros-Ejercicio'!
TransferTransaction subclass: #TransferWithdraw
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Ejercicio'!

!TransferWithdraw methodsFor: 'value' stamp: 'MS 6/8/2022 23:30:49'!
beAddedTo: aBalance

	^aBalance - self value.! !


!TransferWithdraw methodsFor: 'main protocol' stamp: 'MS 6/8/2022 23:29:58'!
counterpart

	^transfer depositLeg.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferWithdraw class' category: 'ServiciosFinancieros-Ejercicio'!
TransferWithdraw class
	instanceVariableNames: ''!

!TransferWithdraw class methodsFor: 'instance creation' stamp: 'MS 6/8/2022 23:27:31'!
for: aValue in: aTransfer

	^ self new initializeFor: aValue in: aTransfer.! !
