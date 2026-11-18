
/*
============================================================
DAY 7 - SET 2: BANK LOAN PORTFOLIO
MongoDB 8.0
THREE $LOOKUP AGGREGATION PIPELINES
============================================================

Database: Hexaware_Day7_Banking

Collections:
1. customers
2. loans
3. repayments

============================================================
*/

const bankDB = db.getSiblingDB("Hexaware_Day7_Banking");


/* ============================================================
   PIPELINE 1:
   LOANS WITH CUSTOMER DETAILS

   Business requirement:
   Display each loan along with the details of the customer
   who borrowed the loan.

   Uses:
   $lookup, $unwind, $project, $sort
   ============================================================ */

print("\n");
print("==================================================");
print("PIPELINE 1: LOANS WITH CUSTOMER DETAILS");
print("==================================================");

const pipeline1 = [
    {
        $lookup: {
            from: "customers",
            localField: "CustomerID",
            foreignField: "CustomerID",
            as: "CustomerDetails"
        }
    },
    {
        $unwind: "$CustomerDetails"
    },
    {
        $project: {
            _id: 0,
            LoanID: 1,
            LoanType: 1,
            LoanAmount: 1,
            OutstandingAmount: 1,
            LoanDate: 1,
            BranchID: 1,
            CustomerID: 1,
            CustomerName: "$CustomerDetails.CustomerName",
            CustomerEmail: "$CustomerDetails.Email",
            CustomerPhone: "$CustomerDetails.Phone"
        }
    },
    {
        $sort: {
            LoanID: 1
        }
    }
];

bankDB.loans.aggregate(pipeline1).forEach(printjson);


/* ============================================================
   PIPELINE 2:
   LOANS WITH ALL REPAYMENT DETAILS

   Business requirement:
   Display every loan along with its complete repayment
   history, including installment number, due date,
   payment date and amount paid.

   Uses:
   $lookup, $addFields, $project, $sort
   ============================================================ */

print("\n");
print("==================================================");
print("PIPELINE 2: LOANS WITH REPAYMENT DETAILS");
print("==================================================");

const pipeline2 = [
    {
        $lookup: {
            from: "repayments",
            localField: "LoanID",
            foreignField: "LoanID",
            as: "RepaymentDetails"
        }
    },
    {
        $addFields: {
            TotalInstallments: {
                $size: "$RepaymentDetails"
            },
            TotalAmountPaid: {
                $sum: "$RepaymentDetails.AmountPaid"
            }
        }
    },
    {
        $project: {
            _id: 0,
            LoanID: 1,
            CustomerID: 1,
            LoanType: 1,
            LoanAmount: 1,
            OutstandingAmount: 1,
            TotalInstallments: 1,
            TotalAmountPaid: 1,
            RepaymentDetails: 1
        }
    },
    {
        $sort: {
            LoanID: 1
        }
    }
];

bankDB.loans.aggregate(pipeline2).forEach(printjson);


/* ============================================================
   PIPELINE 3:
   LOANS WITH CUSTOMER DETAILS AND LAST REPAYMENT

   Business requirement:
   Display each loan with customer details and its
   most recent successful repayment.

   The repayment lookup:
   1. Matches the current LoanID.
   2. Excludes unpaid installments.
   3. Sorts successful repayments by PaymentDate.
   4. Returns only the latest repayment.

   Uses:
   $lookup with pipeline, $match, $expr,
   $sort, $limit, $unwind, $project
   ============================================================ */

print("\n");
print("==================================================");
print("PIPELINE 3: LOANS WITH LAST REPAYMENT");
print("==================================================");

const pipeline3 = [
    {
        $lookup: {
            from: "customers",
            localField: "CustomerID",
            foreignField: "CustomerID",
            as: "CustomerDetails"
        }
    },
    {
        $unwind: "$CustomerDetails"
    },
    {
        $lookup: {
            from: "repayments",
            let: {
                currentLoanID: "$LoanID"
            },
            pipeline: [
                {
                    $match: {
                        $expr: {
                            $and: [
                                {
                                    $eq: [
                                        "$LoanID",
                                        "$$currentLoanID"
                                    ]
                                },
                                {
                                    $ne: [
                                        "$PaymentDate",
                                        null
                                    ]
                                }
                            ]
                        }
                    }
                },
                {
                    $sort: {
                        PaymentDate: -1,
                        RepaymentID: -1
                    }
                },
                {
                    $limit: 1
                },
                {
                    $project: {
                        _id: 0,
                        RepaymentID: 1,
                        InstallmentNumber: 1,
                        DueDate: 1,
                        PaymentDate: 1,
                        AmountPaid: 1
                    }
                }
            ],
            as: "LastRepayment"
        }
    },
    {
        $unwind: {
            path: "$LastRepayment",
            preserveNullAndEmptyArrays: true
        }
    },
    {
        $project: {
            _id: 0,
            LoanID: 1,
            LoanType: 1,
            LoanAmount: 1,
            OutstandingAmount: 1,
            CustomerID: 1,
            CustomerName: "$CustomerDetails.CustomerName",
            CustomerEmail: "$CustomerDetails.Email",
            LastRepayment: {
                $ifNull: [
                    "$LastRepayment",
                    "No successful repayment"
                ]
            }
        }
    },
    {
        $sort: {
            LoanID: 1
        }
    }
];

bankDB.loans.aggregate(pipeline3).forEach(printjson);


/* ============================================================
   FINAL VERIFICATION
   ============================================================ */

print("\n");
print("==================================================");
print("ALL THREE BANKING PIPELINES EXECUTED");
print("==================================================");

print("Customers: " + bankDB.customers.countDocuments());
print("Loans: " + bankDB.loans.countDocuments());
print("Repayments: " + bankDB.repayments.countDocuments());

print("\nDAY 7 SET 2 MONGODB REPORTS COMPLETED!");
