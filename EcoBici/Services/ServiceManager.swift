//
//  ServiceManager.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/30/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation

public class ServiceManager : NSObject, URLSessionDelegate, URLSessionTaskDelegate{
    
    func getAccessToken(referenceController: HomeController){
        let todoEndPoint: String = "https://pubsbapi.smartbike.com/oauth/v2/token?="
        //https://pubsbapi.smartbike.com/oauth/v2/token?=
        //https://pubsbapi.smartbike.com/oauth/v2/token
        guard let url = URL(string: todoEndPoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let parameters = [
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "grant_type": "client_credentials"
        ]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        do {
            
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            
            print(error.localizedDescription)
        }
        
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = setTimeOutRequest
        configuration.timeoutIntervalForResource = setTimeOutResource
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        startRequest(session: session, urlRequest: urlRequest, typeRequest: ACCESS_TOKEN, referenceController: referenceController)
    }
    
//    func refreshToken(){
//
//    }
	
	func startRequest(session: URLSession, urlRequest: URLRequest, typeRequest: Int, referenceController: HomeController){
		let task = session.dataTask(with: urlRequest) { (data, response, error) in

            // Errores
            guard error == nil else {
                print(" Error en la petición del servicio")
                print(error!)

                DispatchQueue.main.async{

                    referenceController.errorsEvents()
                }

                return
            }

            guard let responseData = data else {
                print("Error: servicio viene vacio")

                DispatchQueue.main.async{

                     referenceController.errorsEvents()
                }

                return
            }

            print("la respuesta es")
            let realResponse = response as! HTTPURLResponse

            switch realResponse.statusCode {
            case 200:
                do {
                    

                    //print("es diccionario")
                    //print(finalResponse.description)

					switch typeRequest{
					case ACCESS_TOKEN:
						guard let tokenObject = try? JSONDecoder().decode(AccessToken.self, from: responseData) else {
							print("Error al parsear el JSON, error en las credenciales")
							
							DispatchQueue.main.async{

								referenceController.errorsEvents()
							}
							
							return
						}
					
                        DispatchQueue.main.async {
                            self.responseAccessToken(finalResponse: tokenObject, referenceController: referenceController as! HomeController)
                        }
                        
                        
					case REFRESH_TOKEN:
						print("")
					default:
						break
					}
                    

                } catch  {
                    print("error al parsear el json")

                    return
                }

            default:
                print("Estatus http no manejado \(realResponse.statusCode)")

                DispatchQueue.main.async{

                    referenceController.errorsEvents()
                }
            }

        }
        task.resume()
	}
    
	func responseAccessToken(finalResponse: AccessToken, referenceController: HomeController){
        accessToken = finalResponse.access_token ?? ""
		refreshToken = finalResponse.refresh_token ?? ""
		
		/////////////////// Mostrar controller mapa
		referenceController.showMapController()
	}
	
}
