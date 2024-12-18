import FinanceModel from "../models/finance.model.js";


class FinanceController {
    constructor() {
        this.financeModel = new FinanceModel();
    }

    // Please use arrow function to bind 'this' to the class

    getAll = async (req, res) => {
        const finances = await this.financeModel.getAll(req.pool, req.businessId);
        res.json(finances);
    }

    getAllExpenses = async (req, res) => {
        const finances = await this.financeModel.getAllExpenses(req.pool, req.businessId);
        res.json(finances);
    }

    getAllProfits = async (req, res) => {
        const finances = await this.financeModel.getAllProfits(req.pool, req.businessId);
        res.json(finances);
    }

    getByDealId = async (req, res) => {
        const finances = await this.financeModel.getByDealId(req.pool, req.params.id);
        res.json(finances);
    }

    getById = async (req, res) => {
        const finance = await this.financeModel.getById(req.pool, req.params.id);
        res.json(finance);
    }

    add = async (req, res) => {
        const financeData = req.body;
        if(!financeData.business_id || !financeData.amount || !financeData.description || !financeData.deal_id || !financeData.type || !financeData.payment_method) {
            return res.status(400).json({error: 'All data are required'});
        }

        const result = await this.financeModel.add(req.pool, financeData);
        res.json({success: result});
    }

    getByDealIdSummary = async (req, res) => {
        const finances = await this.financeModel.getByDealIdSummary(req.pool, req.params.id);
        res.json(finances);
    }
    

}


export default FinanceController;