//
//  api.swift
//  i3
//
//  Copyright (c) 2015 Innotronic Ingenieurbüro GmbH. All rights reserved.

import Foundation


func getJSON( url: NSURL, callback: (NSDictionary?, String?) -> Void ) -> Void
{
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL( url, completionHandler:
        { data, response, error -> Void in
        
            if( error != nil )
            {
                callback( nil, error!.localizedDescription )
                return
            }
            
            
            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData( data!, options: .AllowFragments ) as? NSDictionary
                callback( json, nil )
                
            }
                
            catch let error as NSError
            {
                callback( nil, error.localizedDescription )
            }
                
            catch
            {
                callback( nil, "Error while parsing JSON" )
            }
        }
    )
    
    task.resume()
}
