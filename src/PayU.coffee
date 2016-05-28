module.exports = (Promise, request, crypto, EventEmitter, xml2js, moment)->
    class PayU extends EventEmitter

        _posId: null
        _posAuthKey: null
        _key1: null
        _key2: null

        statusAuto: null

        paymentEnumerations =
            '1': 'New'
            '2': 'Cancelled'
            '3': 'Rejected'
            '4': 'Started'
            '5': 'Awaiting'
            '7': 'Returned'
            '99': 'Success'
            '888': 'Error'

        methodEnumerations =
            'status': 'Payment/get'
            'create': 'NewPayment'
            'confirm': 'Payment/confirm'
            'cancel': 'Payment/cancel'

        constructor: (options={})->
            super()
            throw new Error("posId property is required") unless options.posId
            throw new Error("posAuthKey property is required") unless options.posAuthKey
            throw new Error("key1 property is required") unless options.key1
            throw new Error("key2 property is required") unless options.key2

            @_posId = options.posId
            @_posAuthKey = options.posAuthKey
            @_key1 = options.key1
            @_key2 = options.key2

            @statusAuto = if options.statusAuto then options.statusAuto else true

        handleNotification: (payload)->

        fetchPaymentStatus: (sessionId)->
            return new Promise (resolve, reject)=>
                configObj =
                    uri: @_getUrl(methodEnumerations.status)
                    form: @_createStatusRequest(sessionId)

                request.post  configObj, (err, response, body)=>
                    

        _validateNotificationSig: ()->
            return

        _createStatusRequest: (sessionId)->
            payload =
                pos_id: @_posId
                session_id: sessionId
                ts: moment().format('x')

            payload.sig = crypto.createHash('md5')
            .update(String(pos_id))
            .update(String(session_id))
            .update(String(ts))
            .update(String(@_key1))
            .digest('hex')

            return payload

        _getUrl: (procedure)->
            return "https://secure.payu.com/paygw/UTF/#{procedure}"
