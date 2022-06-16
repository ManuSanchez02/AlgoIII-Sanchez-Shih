!classDefinition: #AccountSummaryTests category: 'ServiciosFinancieros-Solucion'!
TestCase subclass: #AccountSummaryTests
	instanceVariableNames: 'anAccount aReceiverAccount aSenderAccount anotherAccount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!AccountSummaryTests methodsFor: 'setUp/tearDown' stamp: 'MS 6/16/2022 17:38:12'!
setUp
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	aReceiverAccount := ReceptiveAccount new.
	aSenderAccount := ReceptiveAccount new.! !


!AccountSummaryTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:43:25'!
test01AccountWithNoTransactionsHasZeroBalanceInAccountSummary
	| expectedSummary |

	expectedSummary := OrderedCollection with: 'Balance = 0 * pesos'.
	
	self assertAccountSummaryFor: anAccount is: expectedSummary.! !

!AccountSummaryTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:43:17'!
test02ReceptiveAccountWithDepositHasDepositAndBalanceInAccountSummary
	| expectedSummary |
	
	Deposit register: 20*peso on: anAccount.
	expectedSummary := OrderedCollection with: 'Depósito por 20 * pesos' with: 'Balance = 20 * pesos'.
	
	self assertAccountSummaryFor: anAccount is: expectedSummary.! !

!AccountSummaryTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:42:59'!
test03ReceptiveAccountWithWithdrawHasWithdrawAndBalanceInAccountSummary
	| expectedSummary |
	
	Withdraw register: 30*peso on: anAccount.
	expectedSummary := OrderedCollection with: 'Extracción por 30 * pesos' with: 'Balance = -30 * pesos'.

	self assertAccountSummaryFor: anAccount is: expectedSummary.! !

!AccountSummaryTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:42:44'!
test04ReceptiveAccountWithOutgoingTransferHasOutgoingTransferAndBalanceInAccountSummary
	| expectedSummary |
	
	Transfer amount: 20*peso from: aSenderAccount to: aReceiverAccount.
		
	expectedSummary := OrderedCollection with: 'Salida por transferencia de 20 * pesos' with: 'Balance = -20 * pesos'.
	
	self assertAccountSummaryFor: aSenderAccount is: expectedSummary.! !

!AccountSummaryTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:41:42'!
test05ReceptiveAccountWithIncomingTransferHasIncomingTransferAndBalanceInAccountSummary
	| expectedSummary |
	
	Transfer amount: 30*peso from: aSenderAccount to: aReceiverAccount.
		
	expectedSummary := OrderedCollection with: 'Entrada por transferencia de 30 * pesos' with: 'Balance = 30 * pesos'.
	
	self assertAccountSummaryFor: aReceiverAccount is: expectedSummary ! !

!AccountSummaryTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:41:15'!
test06ReceptiveAccountWithMultipleTransactionsHasThemIncludedInSummary
	| expectedSummary |

	Deposit register: 30*peso on: anAccount.
	Withdraw register: 20*peso on: anAccount.
	Transfer amount: 50*peso from: anAccount to: anotherAccount.
	Transfer amount: 100*peso from: anotherAccount to: anAccount.
		
	expectedSummary := OrderedCollection newFrom: 	{
		'Depósito por 30 * pesos'.
		'Extracción por 20 * pesos'.
		'Salida por transferencia de 50 * pesos'.
		'Entrada por transferencia de 100 * pesos'.
		'Balance = 60 * pesos'.
	}.
	
	self assertAccountSummaryFor: anAccount is: expectedSummary.! !

!AccountSummaryTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:40:52'!
test07PortfolioWithMultipleTransactionsHasThemIncludedInSummary
	| aPortfolio expectedSummary |
	
	aPortfolio := Portfolio with: anAccount with: anotherAccount.
	
	Deposit register: 30*peso on: anAccount.
	Withdraw register: 20*peso on: anAccount.
	Transfer amount: 50*peso from: anAccount to: anotherAccount.
	Transfer amount: 100*peso from: anotherAccount to: anAccount.
		
	expectedSummary := OrderedCollection newFrom: 	{
		'Depósito por 30 * pesos'.
		'Extracción por 20 * pesos'.
		'Salida por transferencia de 50 * pesos'.
		'Entrada por transferencia de 100 * pesos'.
		'Entrada por transferencia de 50 * pesos'.
		'Salida por transferencia de 100 * pesos'.
		'Balance = 10 * pesos'.
	}.
	
	self assertAccountSummaryFor: aPortfolio is: expectedSummary.! !


!AccountSummaryTests methodsFor: 'asserting' stamp: 'MS 6/16/2022 17:48:06'!
assertAccountSummaryFor: anAccountToBeReported is: anExpectedSummary
	
	self assert: anExpectedSummary equals: (AccountSummary for: anAccountToBeReported) generate.! !


!classDefinition: #PortfolioTest category: 'ServiciosFinancieros-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:27:00'!
test02BalanceOfPortfolioWithOneAccountIsAccountBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 * peso on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:27:06'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 * peso on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 * peso on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:27:12'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100 * peso))! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:27:18'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 * peso on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:27:26'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 * peso on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 * peso on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:28:08'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 * peso on: account.
	anotherAccountWithdraw := Withdraw register: 100 * peso on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:28:20'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 * peso on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 * peso on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'LL 11/29/2021 18:55:37'!
test12PortfolioCanNotIncludeItself

	| simplePortfolio |
	
	simplePortfolio := Portfolio new.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 0 equals: simplePortfolio accountsSize. ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #PortfolioTreePrinterTests category: 'ServiciosFinancieros-Solucion'!
TestCase subclass: #PortfolioTreePrinterTests
	instanceVariableNames: 'indent johnsEmptyPortfolio johnsAccount manusAccount mariasAccount angiesAccount myAccount johnsPortfolio mariasPortfolio'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!PortfolioTreePrinterTests methodsFor: 'setUp/tearDown' stamp: 'MS 6/16/2022 18:26:35'!
setUp
	indent := '    '.
	
	johnsAccount := ReceptiveAccount named: 'Cuenta de Juan'.
	manusAccount := ReceptiveAccount named: 'Cuenta de Manu'.
	mariasAccount := ReceptiveAccount named: 'Cuenta de Maria'.
	angiesAccount := ReceptiveAccount named: 'Cuenta de Angeles'.
	myAccount := ReceptiveAccount named: 'Cuenta mia'.
	
	johnsEmptyPortfolio := Portfolio named: 'Portfolio de Juan'.
	johnsPortfolio := Portfolio named: 'Portfolio de Juan' with: johnsAccount.
	mariasPortfolio := Portfolio named: 'Portfolio de Maria' with: mariasAccount.! !


!PortfolioTreePrinterTests methodsFor: 'asserting' stamp: 'MS 6/16/2022 18:27:08'!
assertBriefTreePrintOfPortfolio: aPortfolioToBePrinted isEqualTo: aBriefPortfolioTreePrint

	self assert: aBriefPortfolioTreePrint equals: (PortfolioBriefTreePrinter with: aPortfolioToBePrinted) generate.! !

!PortfolioTreePrinterTests methodsFor: 'asserting' stamp: 'MS 6/16/2022 18:27:06'!
assertDetailedTreePrintOfPortfolio: aPortfolioToBePrinted isEqualTo: aDetailedPortfolioTreePrint

	self assert: aDetailedPortfolioTreePrint equals: (PortfolioDetailedTreePrinter with: aPortfolioToBePrinted) generate.! !


!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:25:54'!
test01PortfolioDetailedTreePrinterOnlyPrintsEmptyPortfolioName

	| expectedPortfolioStructure |

	expectedPortfolioStructure := OrderedCollection with: 'Portfolio de Juan' with: indent, 'Balance = 0 * pesos'.
	
	self assertDetailedTreePrintOfPortfolio: johnsEmptyPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:26:44'!
test02PortfolioWithAccountAndNoTransactionsIsPrintedCorrectly
	| expectedPortfolioStructure |

	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de Juan'.
		indent,'Cuenta de Juan'.
		indent,indent,'Balance = 0 * pesos'.
		indent,'Balance = 0 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: johnsPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:27:25'!
test03PortfolioWithPortfolioWithNoTransactionsIsPrintedCorrectly
	| aPortfolio expectedPortfolioStructure |

	aPortfolio := Portfolio named: 'Portfolio de la familia' with: mariasPortfolio.
	
	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de la familia'.
		indent,'Portfolio de Maria'.
		indent,indent,'Cuenta de Maria'.
		indent,indent,indent,'Balance = 0 * pesos'.
		indent,indent,'Balance = 0 * pesos'.
		indent,'Balance = 0 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: aPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:27:38'!
test04PortfolioWithMultipleAccountsWithNoTransactionsIsPrintedCorrectly
	| familysPortfolio expectedPortfolioStructure |

	familysPortfolio := Portfolio named: 'Portfolio de la familia' with: manusAccount with: mariasPortfolio.
	
	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de la familia'.
		indent,'Cuenta de Manu'.
		indent,indent,'Balance = 0 * pesos'.
		indent,'Portfolio de Maria'.
		indent,indent,'Cuenta de Maria'.
		indent,indent,indent,'Balance = 0 * pesos'.
		indent,indent,'Balance = 0 * pesos'.
		indent,'Balance = 0 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: familysPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:27:47'!
test05PortfolioWithAccountWithDepositIsPrintedCorrectly
	| expectedPortfolioStructure |

	Deposit register: 100*peso on: johnsAccount .
	
	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de Juan'.
		indent,'Cuenta de Juan'.
		indent,indent,'Depósito por 100 * pesos'.
		indent,indent,'Balance = 100 * pesos'.
		indent,'Balance = 100 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: johnsPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:28:07'!
test06PortfolioWithAccountWithWithdrawIsPrintedCorrectly
	| expectedPortfolioStructure |

	Withdraw register: 20*peso on: johnsAccount .
	
	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de Juan'.
		indent,'Cuenta de Juan'.
		indent,indent,'Extracción por 20 * pesos'.
		indent,indent,'Balance = -20 * pesos'.
		indent,'Balance = -20 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: johnsPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:28:14'!
test07PortfolioWithSenderAccountInTransferIsPrintedCorrectly
	| expectedPortfolioStructure |

	Transfer amount: 50*peso from: johnsAccount  to: mariasAccount .
		
	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de Juan'.
		indent,'Cuenta de Juan'.
		indent,indent,'Salida por transferencia de 50 * pesos'.
		indent,indent,'Balance = -50 * pesos'.
		indent,'Balance = -50 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: johnsPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:28:21'!
test08PortfolioWithReceivingAccountInTransferIsPrintedCorrectly
	| expectedPortfolioStructure |

	Transfer amount: 75*peso from: mariasAccount to: johnsAccount.
		
	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de Juan'.
		indent,'Cuenta de Juan'.
		indent,indent,'Entrada por transferencia de 75 * pesos'.
		indent,indent,'Balance = 75 * pesos'.
		indent,'Balance = 75 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: johnsPortfolio isEqualTo: expectedPortfolioStructure.! !

!PortfolioTreePrinterTests methodsFor: 'detailed tree printer tests' stamp: 'MS 6/16/2022 18:28:43'!
test09PortfolioWithMultipleAccountsAndTransactionsIsPrintedCorrectly
	| familyPortfolio expectedPortfolioStructure childrenPortfolio |

	childrenPortfolio := Portfolio named: 'Portfolio de hijos' with: johnsAccount with: angiesAccount. 

	familyPortfolio := Portfolio named: 'Portfolio de la familia' with: myAccount with: childrenPortfolio.
	
	Deposit register: 20*peso on: myAccount.
	Withdraw register: 70*peso on: myAccount.
	Deposit register: 35*peso on: johnsAccount .
	Withdraw register: 5*peso on: johnsAccount.
	Transfer amount: 10*peso from: angiesAccount to: manusAccount .

	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de la familia'.
		
		indent,'Cuenta mia'.
		indent,indent,'Depósito por 20 * pesos'.
		indent,indent,'Extracción por 70 * pesos'.
		indent,indent,'Balance = -50 * pesos'.
		
		indent,'Portfolio de hijos'.
		indent,indent,'Cuenta de Juan'.
		indent,indent,indent,'Depósito por 35 * pesos'.
		indent,indent,indent,'Extracción por 5 * pesos'.
		indent,indent,indent,'Balance = 30 * pesos'.
		
		indent,indent,'Cuenta de Angeles'.
		indent,indent,indent,'Salida por transferencia de 10 * pesos'.
		indent,indent,indent,'Balance = -10 * pesos'.
		indent,indent,'Balance = 20 * pesos'.
		
		indent,'Balance = -30 * pesos'.
	}.
	
	self assertDetailedTreePrintOfPortfolio: familyPortfolio isEqualTo: expectedPortfolioStructure.! !


!PortfolioTreePrinterTests methodsFor: 'brief tree printer tests' stamp: 'MS 6/16/2022 18:29:35'!
test01PortfolioTreePrinterOnlyPrintsEmptyPortfolioName
	| expectedPortfolioStructure |

	expectedPortfolioStructure := OrderedCollection with: 'Portfolio de Juan'.
	self assertBriefTreePrintOfPortfolio: johnsEmptyPortfolio isEqualTo: expectedPortfolioStructure.
	
	! !

!PortfolioTreePrinterTests methodsFor: 'brief tree printer tests' stamp: 'MS 6/16/2022 18:30:05'!
test02PortfolioTreePrinterPrintsPortfolioNameWithPortfolioAccount
	| expectedPortfolioStructure |

	expectedPortfolioStructure := OrderedCollection with: 'Portfolio de Juan' with: indent,'Cuenta de Juan'.
	self assertBriefTreePrintOfPortfolio: johnsPortfolio isEqualTo: expectedPortfolioStructure.
	
	! !

!PortfolioTreePrinterTests methodsFor: 'brief tree printer tests' stamp: 'MS 6/16/2022 18:30:19'!
test03PortfolioTreePrinterPrintsPortfolioNameWithPortfolioAccounts
	| aPortfolio expectedPortfolioStructure |

	aPortfolio := Portfolio named: 'Portfolio de Juan y Maria' with: johnsAccount with: mariasAccount .
	expectedPortfolioStructure := OrderedCollection with: 'Portfolio de Juan y Maria' with: indent,'Cuenta de Juan' with: indent,'Cuenta de Maria'.
	
	self assertBriefTreePrintOfPortfolio: aPortfolio isEqualTo: expectedPortfolioStructure.
	
	! !

!PortfolioTreePrinterTests methodsFor: 'brief tree printer tests' stamp: 'MS 6/16/2022 18:30:44'!
test04NestedPortfolioIsPrintedCorrectly
	| familysPortfolio expectedPortfolioStructure mariaAndManuPortfolio |
	
	mariaAndManuPortfolio := Portfolio named: 'Portfolio de Maria y Manu' with: mariasAccount with: manusAccount .
	familysPortfolio := Portfolio named: 'Portfolio de Familia' with: johnsAccount with: mariaAndManuPortfolio .
	
	expectedPortfolioStructure := OrderedCollection newFrom: {
		'Portfolio de Familia'.
		indent,'Cuenta de Juan'.
		indent,'Portfolio de Maria y Manu'.
		indent,indent,'Cuenta de Maria'.
		indent,indent,'Cuenta de Manu'.
	}.
	
	self assertBriefTreePrintOfPortfolio: familysPortfolio isEqualTo: expectedPortfolioStructure.
	
	! !


!classDefinition: #ReceptiveAccountTest category: 'ServiciosFinancieros-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'MS 6/12/2022 19:34:40'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0*peso equals: account balance
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'LL 7/1/2021 03:14:20'!
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


!classDefinition: #TransferNetTests category: 'ServiciosFinancieros-Solucion'!
TestCase subclass: #TransferNetTests
	instanceVariableNames: 'anAccount anotherAccount aReceiverAccount2 aSenderAccount2 externalAccount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!TransferNetTests methodsFor: 'setUp/tearDown' stamp: 'MS 6/16/2022 17:46:38'!
setUp
	anAccount := ReceptiveAccount new.
	anotherAccount := ReceptiveAccount new.
	externalAccount := ReceptiveAccount new.
! !


!TransferNetTests methodsFor: 'asserting' stamp: 'MS 6/16/2022 17:53:49'!
assertTransferNetFor: anAccountToBeReported equals: anExpectedValue.

	self assert: anExpectedValue equals: (TransferNet for: anAccountToBeReported) generate.! !


!TransferNetTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:48:30'!
test01AccountWithNoTransfersHasZeroTransferNetValue

	self assertTransferNetFor: anAccount equals: 0 * peso.! !

!TransferNetTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:48:55'!
test02AccountWithTransferDepositHasTransferValueAsTransferNetValue
	
	Transfer amount: 10 * peso from: anotherAccount to: anAccount .
	
	self assertTransferNetFor: anAccount equals: 10 * peso.! !

!TransferNetTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:49:07'!
test03AccountWithTransferWithdrawHasNegativeTransferValueAsTransferNetValue
	
	Transfer amount: 10 * peso from: anAccount to: anotherAccount .
	
	self assertTransferNetFor: anAccount equals: -10 * peso.! !

!TransferNetTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:49:22'!
test04AccountWithMultipleTransfersHasCorrectNetTransferValue

	Transfer amount: 10 * peso from: anAccount to: anotherAccount .
	Transfer amount: 20 * peso from: anotherAccount to: anAccount .

	self assertTransferNetFor: anAccount equals: 10 * peso.! !

!TransferNetTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:49:37'!
test05TransferNetIgnoresDepositTransaction
	
	Deposit register: 400 * peso on: anAccount.
	
	self assertTransferNetFor: anAccount equals: 0 * peso.! !

!TransferNetTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:49:54'!
test06TransferNetIgnoresWithdrawTransaction

	Withdraw register: 400 * peso on: anAccount.
	
	self assertTransferNetFor: anAccount equals: 0 * peso.! !

!TransferNetTests methodsFor: 'tests' stamp: 'MS 6/16/2022 17:54:04'!
test07PortfolioWithMultipleTransfersHasCorrectNetTransferValue
	|  aPortfolio  |
	
	aPortfolio := Portfolio with: anAccount with: anotherAccount.
	
	Transfer amount: 10 * peso from: anAccount to: anotherAccount .
	Transfer amount: 20 * peso from: anotherAccount to: externalAccount .

	self assertTransferNetFor: aPortfolio equals: -20*peso ! !


!classDefinition: #TransferTest category: 'ServiciosFinancieros-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 21:07:03'!
test01ATransferDecreasesBalanceFromOriginAccountAndIncreasesItForDestinationAccount

	| destinationAccount originAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: 8 * peso equals: originAccount balance.
	self assert: 12 * peso equals: destinationAccount balance.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 21:12:28'!
test02ATransferKnowsItsValue

	| destinationAccount originAccount transfer |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	transfer := Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: 2 * peso equals: transfer value.! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:01:44'!
test03DepositLegKnowsItsWithdrawCounterpart

	| destinationAccount originAccount transfer |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	transfer := Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: transfer withdrawLeg equals: transfer depositLeg withdrawLeg! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:01:51'!
test04WithdrawLegKnowsItsDepositCounterpart

	| destinationAccount originAccount transfer |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: destinationAccount.
	
	transfer := Transfer amount: 2 * peso from: originAccount to: destinationAccount.
	
	self assert: transfer depositLeg equals: transfer withdrawLeg depositLeg! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:02:36'!
test05OriginAndDestinationAccountsCannotBeTheSame

	| originAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	self should: [ Transfer amount: 2 * peso from: originAccount to: originAccount ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Transfer cannotTransferToOriginErrorDescription equals: anError messageText.
			self assert: 10 * peso equals: originAccount balance.
		]
! !

!TransferTest methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 23:02:44'!
test06CannotTransferAZeroAmount

	| originAccount destinationAccount |
	
	originAccount := ReceptiveAccount new.
	Deposit register: 10 * peso on: originAccount.
	
	destinationAccount := ReceptiveAccount new.
	Deposit register: 5 * peso on: destinationAccount.
	
	self should: [ Transfer amount: 0 from: originAccount to: destinationAccount ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Transfer cannotTransferZeroErrorDescription equals: anError messageText.
			self assert: 10 * peso equals: originAccount balance.
		]
! !


!classDefinition: #Account category: 'ServiciosFinancieros-Solucion'!
Object subclass: #Account
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!Account methodsFor: 'main protocol' stamp: 'IS 6/15/2022 23:05:42'!
balance

	self subclassResponsibility ! !

!Account methodsFor: 'main protocol' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'main protocol' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !

!Account methodsFor: 'main protocol' stamp: 'IS 6/16/2022 00:11:17'!
visitTransactionsWith: aTransactionVisitor
	self transactions do: [ :aTransaction | aTransaction accept: aTransactionVisitor ]! !


!Account methodsFor: 'composition' stamp: 'LL 7/8/2021 21:45:50'!
addedTo: aPortfolio

	self subclassResponsibility! !

!Account methodsFor: 'composition' stamp: 'LL 7/8/2021 21:46:48'!
isComposedBy: anAccount

	self subclassResponsibility! !


!Account methodsFor: 'private' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !


!Account methodsFor: 'accessing' stamp: 'IS 6/16/2022 00:29:32'!
name
	^name! !


!Account methodsFor: 'visitor' stamp: 'IS 6/16/2022 00:46:29'!
accept: anAccountVisitor
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Account class' category: 'ServiciosFinancieros-Solucion'!
Account class
	instanceVariableNames: ''!

!Account class methodsFor: 'as yet unclassified' stamp: 'IS 6/16/2022 00:12:16'!
named: aName
	
	^self new initializeWithName: aName.! !


!classDefinition: #Portfolio category: 'ServiciosFinancieros-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!Portfolio methodsFor: 'initialization' stamp: 'HAW 5/25/2019 12:03:18'!
initialize

	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !

!Portfolio methodsFor: 'initialization' stamp: 'IS 6/15/2022 23:39:40'!
initializeWithName: aName
	name := aName.
	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'main protocol' stamp: 'IS 6/13/2022 20:25:25'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0* peso ]! !

!Portfolio methodsFor: 'main protocol' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'main protocol' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !


!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !


!Portfolio methodsFor: 'private' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !


!Portfolio methodsFor: 'visitor' stamp: 'IS 6/16/2022 01:21:36'!
accept: anAccountVisitor
	^anAccountVisitor visitPortfolio: self! !

!Portfolio methodsFor: 'visitor' stamp: 'MS 6/16/2022 15:35:50'!
visitAccountsWith: anAccountVisitor
 	accounts do: [ :anAccount | anAccount accept: anAccountVisitor 	].


	! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !

!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'composition' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !

!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !

!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'ServiciosFinancieros-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:48:55'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'IS 6/16/2022 00:13:23'!
named: aPortfolioName with: anAccount	
	| aPortfolio |
	aPortfolio := self new initializeWithName: aPortfolioName.
	
	^aPortfolio
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'IS 6/16/2022 00:13:28'!
named: aPortfolioName with: anAccount with: anotherAccount
	| aPortfolio |
	aPortfolio := self new initializeWithName: aPortfolioName.

	^aPortfolio 
		add: anAccount;
		add: anotherAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:18:21'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'HAW 5/25/2019 11:23:59'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself! !


!classDefinition: #ReceptiveAccount category: 'ServiciosFinancieros-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:35'!
initialize

	super initialize.
	transactions := OrderedCollection new.! !

!ReceptiveAccount methodsFor: 'initialization' stamp: 'IS 6/16/2022 00:12:49'!
initializeWithName: aName

	name := aName.
	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'main protocol' stamp: 'MS 6/12/2022 19:34:48'!
balance

	^transactions 
		inject: 0*peso
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !

!ReceptiveAccount methodsFor: 'main protocol' stamp: 'NR 10/21/2019 18:55:56'!
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


!ReceptiveAccount methodsFor: 'private' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !

!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'visitor' stamp: 'IS 6/16/2022 01:21:31'!
accept: anAccountVisitor
	^anAccountVisitor visitReceptiveAccount: self! !


!classDefinition: #AccountTransaction category: 'ServiciosFinancieros-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'HernanWilkinson 9/12/2011 12:25'!
value 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'visitor' stamp: 'IS 6/15/2022 23:04:57'!
accept: aTransactionVisitor
	self subclassResponsibility ! !


!classDefinition: #Deposit category: 'ServiciosFinancieros-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!Deposit methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:45'!
initializeFor: aValue

	value := aValue ! !


!Deposit methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:38'!
value

	^ value! !


!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'visitor' stamp: 'IS 6/16/2022 00:06:03'!
accept: aTransactionVisitor
	aTransactionVisitor visitDeposit: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'ServiciosFinancieros-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!Deposit class methodsFor: 'as yet unclassified' stamp: 'LL 7/8/2021 21:45:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #TransferLeg category: 'ServiciosFinancieros-Solucion'!
AccountTransaction subclass: #TransferLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!TransferLeg methodsFor: 'value' stamp: 'LL 9/20/2020 22:27:32'!
value

	^transfer value! !


!TransferLeg methodsFor: 'initialization' stamp: 'LL 9/20/2020 22:28:14'!
initializeWith: aTransfer

	transfer := aTransfer! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferLeg class' category: 'ServiciosFinancieros-Solucion'!
TransferLeg class
	instanceVariableNames: ''!

!TransferLeg class methodsFor: 'as yet unclassified' stamp: 'LL 9/20/2020 22:45:01'!
of: aTransfer on: anAccount

	| transaction |
	
	transaction := self new initializeWith: 	aTransfer.
	anAccount register: transaction.	
	
	^transaction! !


!classDefinition: #TransferDepositLeg category: 'ServiciosFinancieros-Solucion'!
TransferLeg subclass: #TransferDepositLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!TransferDepositLeg methodsFor: 'accessing' stamp: 'LL 9/20/2020 22:26:10'!
withdrawLeg

	^transfer withdrawLeg! !


!TransferDepositLeg methodsFor: 'balance' stamp: 'LL 9/20/2020 22:27:49'!
affectBalance: aBalance

	^aBalance + self value! !


!TransferDepositLeg methodsFor: 'visitor' stamp: 'IS 6/16/2022 00:06:11'!
accept: aTransferVisitor
	aTransferVisitor visitTransferDepositLeg: self! !


!classDefinition: #TransferWithdrawLeg category: 'ServiciosFinancieros-Solucion'!
TransferLeg subclass: #TransferWithdrawLeg
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!TransferWithdrawLeg methodsFor: 'accessing' stamp: 'LL 9/20/2020 22:25:47'!
depositLeg

	^transfer depositLeg! !


!TransferWithdrawLeg methodsFor: 'balance' stamp: 'LL 9/20/2020 22:27:55'!
affectBalance: aBalance

	^aBalance - self value! !


!TransferWithdrawLeg methodsFor: 'visitor' stamp: 'IS 6/16/2022 00:06:15'!
accept: aTransferVisitor
	aTransferVisitor visitTransferWithdrawLeg: self! !


!classDefinition: #Withdraw category: 'ServiciosFinancieros-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!Withdraw methodsFor: 'initialization' stamp: 'HernanWilkinson 7/13/2011 18:46'!
initializeFor: aValue

	value := aValue ! !


!Withdraw methodsFor: 'value' stamp: 'HernanWilkinson 7/13/2011 18:33'!
value

	^ value! !


!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'visitor' stamp: 'IS 6/16/2022 00:06:18'!
accept: aTransferVisitor

	aTransferVisitor visitWithdraw: self! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'ServiciosFinancieros-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!Withdraw class methodsFor: 'as yet unclassified' stamp: 'LL 7/8/2021 21:45:05'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #PortfolioTreePrinter category: 'ServiciosFinancieros-Solucion'!
Object subclass: #PortfolioTreePrinter
	instanceVariableNames: 'portfolio portfolioTree treeLevel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!PortfolioTreePrinter methodsFor: 'private - indentation' stamp: 'MS 6/16/2022 17:20:16'!
currentIndent
	| indent |
	indent := ''.
	treeLevel timesRepeat: [indent := indent append: '    '].
	
	^indent.! !

!PortfolioTreePrinter methodsFor: 'private - indentation' stamp: 'MS 6/16/2022 17:20:22'!
decreaseTreeLevel

	^ treeLevel := treeLevel - 1! !

!PortfolioTreePrinter methodsFor: 'private - indentation' stamp: 'MS 6/16/2022 17:20:28'!
increaseTreeLevel

	^ treeLevel := treeLevel + 1! !


!PortfolioTreePrinter methodsFor: 'private - adding' stamp: 'MS 6/16/2022 17:21:06'!
addAccountNameToPortfolioTree: anAccount

	portfolioTree add: (self currentIndent append: anAccount name)! !


!PortfolioTreePrinter methodsFor: 'initialization' stamp: 'MS 6/16/2022 17:19:43'!
initializeWith: aPortfolioToBePrinted 
	
	portfolio := aPortfolioToBePrinted.
	portfolioTree := OrderedCollection new.
	treeLevel := 0.! !


!PortfolioTreePrinter methodsFor: 'private - visits' stamp: 'MS 6/16/2022 17:23:51'!
visitPortfolio: aPortfolio
	self subclassResponsibility.! !

!PortfolioTreePrinter methodsFor: 'private - visits' stamp: 'MS 6/16/2022 17:24:08'!
visitReceptiveAccount: aReceptiveAccount
	self subclassResponsibility.! !


!PortfolioTreePrinter methodsFor: 'main protocol' stamp: 'MS 6/16/2022 17:22:04'!
generate
	portfolio accept: self.
	
	^portfolioTree.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PortfolioTreePrinter class' category: 'ServiciosFinancieros-Solucion'!
PortfolioTreePrinter class
	instanceVariableNames: ''!

!PortfolioTreePrinter class methodsFor: 'instance creation' stamp: 'MS 6/16/2022 17:19:17'!
with: aPortfolioToBePrinted
	^self new initializeWith: aPortfolioToBePrinted ! !


!classDefinition: #PortfolioBriefTreePrinter category: 'ServiciosFinancieros-Solucion'!
PortfolioTreePrinter subclass: #PortfolioBriefTreePrinter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!PortfolioBriefTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:15:48'!
visitPortfolio: aPortfolio

	self addAccountNameToPortfolioTree: aPortfolio.

	self increaseTreeLevel.
	aPortfolio visitAccountsWith: self.
	self decreaseTreeLevel.
	! !

!PortfolioBriefTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:15:48'!
visitReceptiveAccount: aReceptiveAccount
	self addAccountNameToPortfolioTree: aReceptiveAccount.


	
	! !


!classDefinition: #PortfolioDetailedTreePrinter category: 'ServiciosFinancieros-Solucion'!
PortfolioTreePrinter subclass: #PortfolioDetailedTreePrinter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!PortfolioDetailedTreePrinter methodsFor: 'private - adding' stamp: 'MS 6/16/2022 17:15:35'!
addAccountBalanceToPortfolioTree: aReceptiveAccount

	^ portfolioTree add: (self currentIndent,'Balance = ' append: aReceptiveAccount balance asString)! !

!PortfolioDetailedTreePrinter methodsFor: 'private - adding' stamp: 'MS 6/16/2022 17:15:59'!
addDescriptionAsPortfolioTreeLine: aTransactionDescription ofTransaction: aTransaction

	portfolioTree add: (self currentIndent append: (aTransactionDescription , aTransaction value asString)).! !


!PortfolioDetailedTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:16:00'!
visitDeposit: aDeposit
	
	self addDescriptionAsPortfolioTreeLine: 'Depósito por ' ofTransaction: aDeposit.! !

!PortfolioDetailedTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:15:48'!
visitPortfolio: aPortfolio
	self addAccountNameToPortfolioTree: aPortfolio.
	
	self increaseTreeLevel.
	aPortfolio visitAccountsWith: self.	
	self addAccountBalanceToPortfolioTree: aPortfolio.
	self decreaseTreeLevel.! !

!PortfolioDetailedTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:15:48'!
visitReceptiveAccount: aReceptiveAccount
	self addAccountNameToPortfolioTree: aReceptiveAccount.
	
	self increaseTreeLevel.
	aReceptiveAccount visitTransactionsWith: self.
	self addAccountBalanceToPortfolioTree: aReceptiveAccount.
	self decreaseTreeLevel.! !

!PortfolioDetailedTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:15:59'!
visitTransferDepositLeg: aTransferDepositLeg 
	
	self addDescriptionAsPortfolioTreeLine: 'Entrada por transferencia de ' ofTransaction: aTransferDepositLeg.! !

!PortfolioDetailedTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:15:59'!
visitTransferWithdrawLeg: aTransferWithdrawLeg 
	
	self addDescriptionAsPortfolioTreeLine: 'Salida por transferencia de ' ofTransaction: aTransferWithdrawLeg.! !

!PortfolioDetailedTreePrinter methodsFor: 'visits' stamp: 'MS 6/16/2022 17:16:00'!
visitWithdraw: aWithdraw
	
	self addDescriptionAsPortfolioTreeLine: 'Extracción por ' ofTransaction: aWithdraw.! !


!classDefinition: #Report category: 'ServiciosFinancieros-Solucion'!
Object subclass: #Report
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!Report methodsFor: 'visits' stamp: 'IS 6/16/2022 00:10:08'!
visitAccountTransactions
	account visitTransactionsWith: self! !

!Report methodsFor: 'visits' stamp: 'IS 6/16/2022 00:06:45'!
visitDeposit: aDeposit
	self subclassResponsibility ! !

!Report methodsFor: 'visits' stamp: 'IS 6/16/2022 00:06:42'!
visitTransferDepositLeg: aTransferDepositLeg
	self subclassResponsibility ! !

!Report methodsFor: 'visits' stamp: 'IS 6/16/2022 00:06:49'!
visitTransferWithdrawLeg: aTransferWithdrawLeg
	self subclassResponsibility ! !

!Report methodsFor: 'visits' stamp: 'IS 6/16/2022 00:06:54'!
visitWithdraw: aWithdraw
	self subclassResponsibility ! !


!Report methodsFor: 'main protocol' stamp: 'IS 6/15/2022 23:15:02'!
generate
	self subclassResponsibility ! !


!Report methodsFor: 'initialization' stamp: 'IS 6/15/2022 23:15:47'!
initializeFor: anAccountToBeReported
	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Report class' category: 'ServiciosFinancieros-Solucion'!
Report class
	instanceVariableNames: ''!

!Report class methodsFor: 'instance creation' stamp: 'IS 6/15/2022 23:17:24'!
for: anAccountToBeReported
	self subclassResponsibility ! !


!classDefinition: #AccountSummary category: 'ServiciosFinancieros-Solucion'!
Report subclass: #AccountSummary
	instanceVariableNames: 'summary'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!AccountSummary methodsFor: 'initialization' stamp: 'IS 6/15/2022 23:00:21'!
initializeFor: anAccountToBeSummarized 
	account := anAccountToBeSummarized.
	summary := OrderedCollection new.! !


!AccountSummary methodsFor: 'main protocol' stamp: 'IS 6/15/2022 23:14:20'!
generate
	
	
	self visitAccountTransactions.
	summary add: ('Balance = ' append: account balance asString).

	^summary ! !


!AccountSummary methodsFor: 'visits' stamp: 'MS 6/16/2022 18:40:29'!
visitDeposit: aDeposit
	summary add: ('Depósito por ', aDeposit value asString).! !

!AccountSummary methodsFor: 'visits' stamp: 'MS 6/16/2022 18:40:18'!
visitTransferDepositLeg: aTransferDepositLeg
	
	summary add: ('Entrada por transferencia de ', aTransferDepositLeg value asString).! !

!AccountSummary methodsFor: 'visits' stamp: 'MS 6/16/2022 18:40:22'!
visitTransferWithdrawLeg: aTransferWithdrawLeg

	summary add: ('Salida por transferencia de ', aTransferWithdrawLeg value asString).! !

!AccountSummary methodsFor: 'visits' stamp: 'MS 6/16/2022 18:40:26'!
visitWithdraw: aWithdraw
	
	summary add: ('Extracción por ', aWithdraw value asString).! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountSummary class' category: 'ServiciosFinancieros-Solucion'!
AccountSummary class
	instanceVariableNames: ''!

!AccountSummary class methodsFor: 'instance creation' stamp: 'IS 6/16/2022 00:00:00'!
for: anAccountToBeReported
	^self new initializeFor: anAccountToBeReported ! !


!classDefinition: #TransferNet category: 'ServiciosFinancieros-Solucion'!
Report subclass: #TransferNet
	instanceVariableNames: 'netValue'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!TransferNet methodsFor: 'main protocol' stamp: 'IS 6/16/2022 00:15:25'!
generate
	
	self visitAccountTransactions.
	
	^netValue
	! !


!TransferNet methodsFor: 'initialization' stamp: 'IS 6/15/2022 22:40:03'!
initializeFor: anAccount 
	account := anAccount.
	netValue := 0* peso.! !


!TransferNet methodsFor: 'visits' stamp: 'IS 6/16/2022 00:07:28'!
visitDeposit: aDeposit
	! !

!TransferNet methodsFor: 'visits' stamp: 'IS 6/16/2022 00:07:32'!
visitTransferDepositLeg: aTransferDepositLeg
	netValue := netValue + aTransferDepositLeg value
	! !

!TransferNet methodsFor: 'visits' stamp: 'IS 6/16/2022 00:07:39'!
visitTransferWithdrawLeg: aTransferWithdrawLeg
	netValue := netValue - aTransferWithdrawLeg value
	! !

!TransferNet methodsFor: 'visits' stamp: 'IS 6/16/2022 00:07:42'!
visitWithdraw: aWithdraw
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferNet class' category: 'ServiciosFinancieros-Solucion'!
TransferNet class
	instanceVariableNames: ''!

!TransferNet class methodsFor: 'instance creation' stamp: 'IS 6/15/2022 23:18:11'!
for: anAccountToBeReported
	^self new initializeFor: anAccountToBeReported ! !


!classDefinition: #Transfer category: 'ServiciosFinancieros-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'value withdrawLeg depositLeg'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'ServiciosFinancieros-Solucion'!

!Transfer methodsFor: 'value' stamp: 'LL 9/20/2020 21:13:00'!
value

	^value! !


!Transfer methodsFor: 'accessing' stamp: 'LL 9/20/2020 22:39:46'!
depositLeg

	^depositLeg! !

!Transfer methodsFor: 'accessing' stamp: 'LL 9/20/2020 21:25:56'!
withdrawLeg
	
	^withdrawLeg! !


!Transfer methodsFor: 'initialization' stamp: 'LL 9/20/2020 21:25:21'!
initializeWith: aValue withdrawLeg: aWithdraw depositLeg: aDeposit

	value := aValue.
	withdrawLeg := aWithdraw.
	depositLeg := aDeposit! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'ServiciosFinancieros-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 22:57:30'!
cannotTransferToOriginErrorDescription
	
	^'Transfer destionation cannot be the origin account'! !

!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 23:00:53'!
cannotTransferZeroErrorDescription

	^'Transfer amount should be positive'! !

!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 22:56:35'!
signalCannotTransferToOrigin
	
	self error: self cannotTransferToOriginErrorDescription! !

!Transfer class methodsFor: 'errors' stamp: 'LL 9/20/2020 23:06:17'!
signalCannotTransferZero

	self error: self cannotTransferZeroErrorDescription! !


!Transfer class methodsFor: 'assertions' stamp: 'LL 9/20/2020 23:05:22'!
assert: anAmountOfMoney canBeTransferedTo: destinationAccount from: originAccount

	self assertCanTransferTo: destinationAccount from: originAccount.
	self assertCanTransfer: anAmountOfMoney! !

!Transfer class methodsFor: 'assertions' stamp: 'LL 9/20/2020 23:11:50'!
assertCanTransfer: anAmountOfMoney

	^ anAmountOfMoney isZero ifTrue: [ self signalCannotTransferZero ]! !

!Transfer class methodsFor: 'assertions' stamp: 'LL 9/20/2020 23:04:58'!
assertCanTransferTo: destinationAccount from: originAccount

	^ originAccount = destinationAccount ifTrue: [ self signalCannotTransferToOrigin ]! !


!Transfer class methodsFor: 'instance creation' stamp: 'LL 9/20/2020 23:11:34'!
amount: anAmountOfMoney from: originAccount to: destinationAccount 
	
	| transfer depositLeg withdrawLeg |
	
	self assert: anAmountOfMoney canBeTransferedTo: destinationAccount from: originAccount.
	
	transfer := self new.
	
	withdrawLeg := TransferWithdrawLeg of: transfer on: originAccount.
	depositLeg := TransferDepositLeg of: transfer on: destinationAccount.
	
	^transfer initializeWith: anAmountOfMoney withdrawLeg: withdrawLeg depositLeg: depositLeg
	
	
	! !
