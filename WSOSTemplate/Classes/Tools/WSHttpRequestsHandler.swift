//
//  WSHttpRequestsHandler.swift
//  shareba_business
//
//  Created by 吳招坤 on 2018/8/14.
//  Copyright © 2018年 WU CHAO KUN All rights reserved.
//

import SwiftyJSON
import ObjectMapper
import SwiftyJSON
//import DaisyNet
import Alamofire

public enum CacheStyle{
    case ResponseData
    case Cache
    case Both
}

open class WSResponseConfigure<T> {
    
    public var url: String
    public var method: HTTPMethod = .get
    public var params: [String:Any]? = nil
    public var filePath: String? = nil
    public var jsonString: String? = nil
    public var cacheType: CacheStyle = .ResponseData
    
    
    public init() {
        url = ""
        method = .get
        params = nil
        filePath = ""
        jsonString = ""
    }
    
}

open class WSHttpRequestsHandler {
    
    public static func httpRequestsModel(data:Data) ->WSHttpRequestsModel? {
        let jsonString = JSON(data).description
        if jsonString.isEmpty {
            return nil
        }
        if let requestsModel = WSHttpRequestsModel(JSONString: jsonString) {
            return requestsModel;
        }
        return nil
    }

}

open class WSRequestsDataHandler {
    //將資料轉為傳入Model的格式回傳
    public static func ObjectMapperModelSerializer<T: BaseMappable>(_ WSResponseConfigure:WSResponseConfigure<T>, _ context: MapContext? = nil,json:String) -> T? {
        
        if let parsedObject = Mapper<T>(context:context,shouldIncludeNilValues: false).mapArray(JSONString: json) {
            return parsedObject[0]
        }
        return nil
        
    }
    //將資料轉為傳入Model Array的格式回傳
    public static func ObjectMapperArraySerializer<T: BaseMappable>(_ WSResponseConfigure:WSResponseConfigure<T>, _ context: MapContext? = nil,json:String) -> [T]? {
        
        if let parsedObject = Mapper<T>(context:context,shouldIncludeNilValues: false).mapArray(JSONString: json) {
            return parsedObject
        }
        return nil
        
    }
    //處理資料從WSHttpRequestsModel中的Data，開始解析
    public static func handleRequestsDataFromModelData<T: BaseMappable>(entitiesApiData: (([Any],SBErrorType) -> Void)!,responseConfigure:WSResponseConfigure<T> , data: Data) {
        
        if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: data) {
            if requestsModel.status == false {
                entitiesApiData([] , SBErrorType.ConnectError)
                return
            }
            let jsonString = JSON(requestsModel.data ?? []).description;
            let dataBaseModel = WSRequestsDataHandler.ObjectMapperModelSerializer(responseConfigure, json:jsonString)
            let ApiModelDataArray = (dataBaseModel as! WSDataBaseModel).getModelDataArray()
            entitiesApiData(ApiModelDataArray , SBErrorType.ConnectSuccess)
        }
        else {
            entitiesApiData([] , SBErrorType.ConnectError)
        }
        
    }
    //處理資料從得到的Data，開始解析
    public static func handleRequestsDataFromData<T: BaseMappable>(entitiesApiData: (([Any],SBErrorType) -> Void)!,dataResponse:WSResponseConfigure<T> , data: Data) {
        
        if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: data) {
            if requestsModel.status == false {
                entitiesApiData([] , SBErrorType.ConnectError)
                return
            }
            
            let jsonString = JSON(data).description;
            let dataBaseModel = WSRequestsDataHandler.ObjectMapperModelSerializer(dataResponse, json:jsonString)
            let ApiModelDataArray = (dataBaseModel as! WSDataBaseModel).getModelDataArray()
            entitiesApiData(ApiModelDataArray , SBErrorType.ConnectSuccess)
        }
        else {
            entitiesApiData([] , SBErrorType.ConnectError)
        }
        
    }
    
    //傳入jsonString資料，進行處理
    public static func jsonStringHandler<T: BaseMappable>(entitiesApiData: (([Any],SBErrorType) -> Void)!,dataResponse:WSResponseConfigure<T> , jsonString:String) {
        
        let dataBaseModel = WSRequestsDataHandler.ObjectMapperModelSerializer(dataResponse, json:jsonString)
        let ApiModelDataArray = (dataBaseModel as! WSDataBaseModel).getModelDataArray()
        entitiesApiData(ApiModelDataArray , SBErrorType.ConnectSuccess)
        
    }
    //傳入檔案資料，進行處理
    public static func fileHandler<T: BaseMappable>(entitiesApiData: (([Any],SBErrorType) -> Void)!,dataResponse:WSResponseConfigure<T> , filePath:String) {
        
        guard let dataFilePath = Bundle.main.path(forResource: filePath, ofType: "json")
            else {
                entitiesApiData([] , SBErrorType.ConnectError)
                return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: dataFilePath))
            WSRequestsDataHandler.handleRequestsDataFromModelData(entitiesApiData: entitiesApiData,responseConfigure: dataResponse , data: data)
        } catch let error {
            print(error)
            entitiesApiData([] , SBErrorType.ConnectError)
        }
        
    }
    //依傳資料進行對應的資料格式處理
    public static func requestsHandler<T: BaseMappable>(entitiesApiData: (([Any],SBErrorType) -> Void)!,dataResponse:WSResponseConfigure<T>) {
        
        if dataResponse.url != "" {
            WSRequestsDataHandler.httpRequestFromModelDataHandler(entitiesApiData: entitiesApiData,responseConfigure:dataResponse)
        }
        else if dataResponse.filePath != nil {
            WSRequestsDataHandler.fileHandler(entitiesApiData: entitiesApiData,dataResponse:dataResponse , filePath:dataResponse.filePath!)
        }
        else if dataResponse.jsonString != "" {
            WSRequestsDataHandler.jsonStringHandler(entitiesApiData: entitiesApiData,dataResponse:dataResponse , jsonString:dataResponse.jsonString!)
        }
        
    }
    //Http網路呼叫入口，指定資料處理方式從Data開始.以下為公開的主要部份
    public static func httpRequestFromDataHandler<T: BaseMappable>(entitiesApiData: (([Any],SBErrorType) -> Void)!,responseConfigure:WSResponseConfigure<T> ) {
        
        if responseConfigure.cacheType == .Cache {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).cacheData { responseObject in
                WSRequestsDataHandler.handleRequestsDataFromData(entitiesApiData: entitiesApiData,dataResponse: responseConfigure , data: responseObject)
            }
        }
        else if responseConfigure.cacheType == .ResponseData {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseData { value in
                switch value.result {
                case .success(let responseObject):
                    WSRequestsDataHandler.handleRequestsDataFromData(entitiesApiData: entitiesApiData,dataResponse: responseConfigure , data: responseObject)
                case .failure(let error):
                    entitiesApiData([] , SBErrorType.ConnectError)
                    print(error)
                }
            }
        }
        else {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseCacheAndData { value in
                switch value.result {
                case .success(let responseObject):
                    if value.isCacheData {
                        //if responseConfigure.cacheType == .ResponseData {
                        //    return
                        //}
                        print("isCacheData")
                    } else {
                        //if responseConfigure.cacheType == .Cache {
                        //    return
                        //}
                        print("NONCacheData")
                    }
                    WSRequestsDataHandler.handleRequestsDataFromData(entitiesApiData: entitiesApiData,dataResponse: responseConfigure , data: responseObject)
                case .failure(let error):
                    if error._code == -1009 {
                        return
                    }
                    if value.isCacheData {
                        return
                    }
                    entitiesApiData([] , SBErrorType.ConnectError)
                    print(error)
                }
            }
        }
    
    }
    //Http網路呼叫入口，指定資料處理方式從Model Data開始
    public static func httpRequestFromModelDataHandler<T: BaseMappable>(entitiesApiData: (([Any],SBErrorType) -> Void)!,responseConfigure:WSResponseConfigure<T> ) {
        if responseConfigure.cacheType == .Cache {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).cacheData { responseObject in
                WSRequestsDataHandler.handleRequestsDataFromModelData(entitiesApiData: entitiesApiData,responseConfigure: responseConfigure , data: responseObject)
            }
        }
        else if responseConfigure.cacheType == .ResponseData {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseData { value in
                switch value.result {
                case .success(let responseObject):
                    WSRequestsDataHandler
                        .handleRequestsDataFromModelData(entitiesApiData: entitiesApiData,responseConfigure: responseConfigure , data: responseObject)
                case .failure(let error):
                    entitiesApiData([] , SBErrorType.ConnectError)
                    print(error)
                }
            }
        }
        else {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseCacheAndData { value in
                switch value.result {
                case .success(let responseObject):
                    if value.isCacheData {
                        //if responseConfigure.cacheType == .ResponseData {
                        //    return
                        //}
                    } else {
                        //if responseConfigure.cacheType == .Cache {
                        //    return
                        //}
                    }
                    WSRequestsDataHandler
                        .handleRequestsDataFromModelData(entitiesApiData: entitiesApiData,responseConfigure: responseConfigure , data: responseObject)
                case .failure(let error):
                    if error._code == -1009 {
                        return
                    }
                    entitiesApiData([] , SBErrorType.ConnectError)
                    print(error)
                }
            }
        }
    }
            
    //Http網路呼叫入口，指定資料處理方式從Data開始，回傳值為傳入型別的Model
    public static func httpRequestHandlerResponseModel<T: BaseMappable>(responseConfigure:WSResponseConfigure<T>,success:@escaping ((T)->Void ),failure:@escaping ((_ errorType:SBErrorType, _ error:String)->Void )) -> Void {
        if responseConfigure.cacheType == .Cache {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).cacheData { responseObject in
                if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                    if requestsModel.status == false {
                        failure(SBErrorType.ConnectError, requestsModel.error ?? "")
                        return
                    }
                    let jsonString = JSON(requestsModel.data ?? []).description;
                    let dataBaseModel = WSRequestsDataHandler.ObjectMapperModelSerializer(responseConfigure, json:jsonString)
                    success(dataBaseModel!)
                }
                else {
                    failure(SBErrorType.ConnectError, "wuchaokun111")
                }
            }
        }
        else if responseConfigure.cacheType == .ResponseData {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams:responseConfigure.params).cache(true).responseData { value in
                switch value.result {
                case .success(let responseObject):
                    if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                        if requestsModel.status == false {
                            failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                            print(requestsModel.error ?? "")
                            return
                        }
                        let jsonString = JSON(requestsModel.data ?? []).description;
                        let dataBaseModel = WSRequestsDataHandler.ObjectMapperModelSerializer(responseConfigure, json:jsonString)
                        success(dataBaseModel!)
                    }
                    else {
                        failure(SBErrorType.ConnectError, unknown_error)
                    }
                case .failure(let error):
                    print(error)
                    failure(SBErrorType.ConnectError, unknown_error)
                }
            }
        }
        else {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams:responseConfigure.params).cache(true).responseCacheAndData { value in
                switch value.result {
                case .success(let responseObject):
                    if value.isCacheData {
                        //if responseConfigure.cacheType == .ResponseData {
                        //    return
                        //}
                    } else {
                        //if responseConfigure.cacheType == .Cache {
                        //    return
                        //}
                    }
                    if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                        if requestsModel.status == false {
                            failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                            return
                        }
                        let jsonString = JSON(requestsModel.data ?? []).description;
                        let dataBaseModel = WSRequestsDataHandler.ObjectMapperModelSerializer(responseConfigure, json:jsonString)
                        success(dataBaseModel!)
                    }
                    else {
                        failure(SBErrorType.ConnectError, unknown_error)
                    }
                    
                case .failure(let error):
                    if error._code == -1009 {
                        return
                    }
                    print(error)
                    failure(SBErrorType.ConnectError, unknown_error)
                }
            }
        }
    }
    //Http網路呼叫入口，指定資料處理方式從Data開始，回傳值為傳入型別的Array
    public static func httpRequestHandlerResponseArray<T: BaseMappable>(responseConfigure:WSResponseConfigure<T>,success:@escaping (([T])->Void ),failure:@escaping ((_ errorType:SBErrorType, _ error:String)->Void )) -> Void {
        if responseConfigure.cacheType == .Cache {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).cacheData { responseObject in
                if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                    if requestsModel.status == false {
                        failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                        return
                    }
                    let jsonString = JSON(requestsModel.data ?? []).description;
                    let dataBaseModel = WSRequestsDataHandler.ObjectMapperArraySerializer(responseConfigure, json:jsonString)
                    success(dataBaseModel!)
                }
                else {
                    failure(SBErrorType.ConnectError, unknown_error)
                }
            }
        }
        else if responseConfigure.cacheType == .ResponseData {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseData { value in
                switch value.result {
                case .success(let responseObject):
                    if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                        if requestsModel.status == false {
                            failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                            return
                        }
                        let jsonString = JSON(requestsModel.data ?? []).description;
                        let dataBaseModel = WSRequestsDataHandler.ObjectMapperArraySerializer(responseConfigure, json:jsonString)
                        success(dataBaseModel!)
                    }
                    else {
                        failure(SBErrorType.ConnectError, unknown_error)
                    }
                case .failure(let error):
                    print(error)
                    failure(SBErrorType.ConnectError, unknown_error)
                }
            }
        }
        else {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseData { value in
                switch value.result {
                case .success(let responseObject):
                    if value.isCacheData {
                        //if responseConfigure.cacheType == .ResponseData {
                        //    return
                        //}
                        print("isCacheData")
                    } else {
                        //if responseConfigure.cacheType == .Cache {
                        //    return
                        //}
                        print("NONCacheData")
                    }
                    if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                        if requestsModel.status == false {
                            failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                            return
                        }
                        let jsonString = JSON(requestsModel.data ?? []).description;
                        let dataBaseModel = WSRequestsDataHandler.ObjectMapperArraySerializer(responseConfigure, json:jsonString)
                        success(dataBaseModel!)
                    }
                    else {
                        failure(SBErrorType.ConnectError, unknown_error)
                    }
                case .failure(let error):
                    if error._code == -1009 {
                        return
                    }
                    print(error)
                    failure(SBErrorType.ConnectError, unknown_error)
                }
            }
            
        }
    
    }
    //Http網路呼叫入口，指定資料處理方式從Data開始，僅回傳成功或失敗
    public static func httpRequestHandlerResponseNoData<T: BaseMappable>(responseConfigure:WSResponseConfigure<T>,success:@escaping (()->Void ),failure:@escaping ((_ errorType:SBErrorType, _ error:String)->Void )) -> Void {
        
        if responseConfigure.cacheType == .Cache {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).cacheData { responseObject in
                    if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                        if requestsModel.status == false {
                            failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                            return
                        }
                        success()
                    }
                    else {
                        failure(SBErrorType.ConnectError, unknown_error)
                    }
            }
        }
        else if responseConfigure.cacheType == .ResponseData {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseData { value in
                switch value.result {
                case .success(let responseObject):
                    if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                        if requestsModel.status == false {
                            failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                            return
                        }
                        success()
                    }
                    else {
                        failure(SBErrorType.ConnectError, unknown_error)
                    }
                    
                case .failure(let error):
                    print(error)
                    failure(SBErrorType.ConnectError, unknown_error)
                }
            }
        }
        else {
            DaisyNet.request(responseConfigure.url, method:responseConfigure.method,dynamicParams: responseConfigure.params).cache(true).responseCacheAndData { value in
                switch value.result {
                case .success(let responseObject):
                    if value.isCacheData {
                        //if responseConfigure.cacheType == .ResponseData {
                        //    return
                        //}
                        print("isCacheData")
                    } else {
                        //if responseConfigure.cacheType == .Cache {
                        //    return
                        //}
                        print("NONCacheData")
                    }
                    if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: responseObject) {
                        if requestsModel.status == false {
                            failure(SBErrorType.ConnectError, requestsModel.error ?? unknown_error)
                            return
                        }
                        success()
                    }
                    else {
                        failure(SBErrorType.ConnectError, unknown_error)
                    }
                    
                case .failure(let error):
                    if error._code == -1009 {
                        return
                    }
                    print(error)
                    failure(SBErrorType.ConnectError, unknown_error)
                }
            }
            
        }
    }

    public static func removeAllCache(){
        DaisyNet.removeAllCache(completion:{ completion in
            
        })
    }
    
    //同步網路抓取資料
    public static func httpSynchronousRequestHandlerResponseModel<T: BaseMappable>(responseConfigure:WSResponseConfigure<T>) -> (T?, Int) {
        let response = Alamofire.request(responseConfigure.url,
                                         method: responseConfigure.method,
                                         parameters: responseConfigure.params)
            .responseJSON(options: .allowFragments)
        switch response.result {
        case .success(_):
            if let data = response.data {
                if let requestsModel:WSHttpRequestsModel = WSHttpRequestsHandler.httpRequestsModel(data: data) {
                    if requestsModel.status == false {
                        return (nil,requestsModel.httpStatus ?? 0)
                    }
                    let jsonString = JSON(requestsModel.data ?? []).description;
                    return   (WSRequestsDataHandler.ObjectMapperModelSerializer(responseConfigure, json:jsonString)!, 0)
                    }
                }
        case .failure(_):
            return (nil, 0)
        }
        return (nil, 0)
    }

    public static func uploadMultipartFormData(urlString:String,params:[String:Any], formDataArray:[WSFormDataModel], method:HTTPMethod,success:@escaping (()->Void) , failure:@escaping (()->Void)) {

        let url : String = urlString
        Alamofire.upload(multipartFormData: { multipartFormData in
            for formDataModel in formDataArray {
                let imageData:Data = (formDataModel.image!.jpegData(compressionQuality:0.2) ?? nil)!
                let fileExtension:String = formDataModel.fileExtension ?? ".jpeg"
                multipartFormData.append(imageData, withName: formDataModel.name ?? "1", fileName: ((formDataModel.name ?? "1") + fileExtension ), mimeType: formDataModel.mimeType ?? "image/jpeg")
            }
            for (key, value) in params {
                if value is String || value is Int {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
//                if value is String {
//                    let stringValue:String = value as! String
//                    multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
//                }
//                else {
//                    let intValue:Int = value as! Int
//                    //multipartFormData.append(intValue, withName: key)
//                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//                }
            } //Optional for extra parameters
        },
                         to:url)
        { (result) in

            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON
                    {
                        response in
                        print("Response :\(response.result.value ?? "")")
                        success()
                }

            case .failure(let encodingError):
                print("no Error :\(encodingError)")
                failure()
            }
        }
    }
    
}
