//
//  ViewController.swift
//  i3
//
//  Copyright (c) 2015 Innotronic Ingenieurbüro GmbH. All rights reserved.

import UIKit


class i3ViewController: UITableViewController
{
    @IBOutlet weak var ipv4Header: UILabel!
    @IBOutlet weak var ipv4Address: UILabel!
    @IBOutlet weak var ipv4PTR: UILabel!
    @IBOutlet weak var ipv4ASN: UILabel!
    @IBOutlet weak var ipv4Country: UILabel!
    @IBOutlet weak var ipv4Description: UILabel!
    
    @IBOutlet weak var ipv6Header: UILabel!
    @IBOutlet weak var ipv6Address: UILabel!
    @IBOutlet weak var ipv6PTR: UILabel!
    @IBOutlet weak var ipv6ASN: UILabel!
    @IBOutlet weak var ipv6Country: UILabel!
    @IBOutlet weak var ipv6Description: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        // Refresh action
        self.refreshControl?.addTarget( self, action: "updateInfo", forControlEvents: UIControlEvents.ValueChanged )
        
        
        // Notification if app becomes active
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "updateInfo",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil
        )
        
        updateInfo();
    }
    
    
    // Refresh IP Infos
    func updateInfo()
    {
        // Format for last refresh date/time
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        
        
        // Flag to check if both requests are finished
        var ipv4Done = false;
        var ipv6Done = false;
        
        
        // Reset old information
        self.ipv4Header.text = "…"
        self.ipv4Address.text = "…"
        self.ipv4PTR.text = " "
        self.ipv4ASN.text = " "
        self.ipv4Country.text = " "
        self.ipv4Description.text = " "
        
        self.ipv6Header.text = "…"
        self.ipv6Address.text = "…"
        self.ipv6PTR.text = " "
        self.ipv6ASN.text = " "
        self.ipv6Country.text = " "
        self.ipv6Description.text = " "
        
        
        // Set network activity indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        
        if let ipv4url = NSURL( string: "http://ipv4.innotronic.net/api.php" )
        {
            // IPv4 request
            getJSON( ipv4url )
            { ( json, error ) -> Void in
                
                dispatch_async( dispatch_get_main_queue() )
                { () -> Void in
                    
                    self.ipv4Header.text = dateFormatter.stringFromDate( NSDate() )
                    
                    if let dict = json
                    {
                        // Update information
                        self.ipv4Address.text = dict[ "ip" ] as? String
                        self.ipv4PTR.text = dict[ "ptr" ] as? String
                        self.ipv4ASN.text = dict[ "asn" ] as? String
                        self.ipv4Country.text = dict[ "country" ] as? String
                        self.ipv4Description.text = dict[ "desc" ] as? String
                    }
                    else
                    {
                        self.ipv4Address.text = "—"
                        self.ipv4PTR.text = "—"
                        self.ipv4ASN.text = "—"
                        self.ipv4Country.text = "—"
                        self.ipv4Description.text = "—"
                    }
                    
                
                    // Did other request already finish?
                    if( ipv6Done )
                    {
                        // Remove network acitivity indicator and reset "Pull to refresh"
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.refreshControl?.endRefreshing()
                    }
                    else
                    {
                        ipv4Done = true;
                    }
                }
            }
        }
        
        
        if let ipv6url = NSURL( string: "http://ipv6.innotronic.net/api.php" )
        {
            // IPv6 request
            getJSON( ipv6url )
            { ( json, error ) -> Void in
                
                // Update information
                dispatch_async( dispatch_get_main_queue() )
                { () -> Void in
                    
                    self.ipv6Header.text = dateFormatter.stringFromDate( NSDate() )
                    
                    if let dict = json
                    {
                        self.ipv6Address.text = dict[ "ip" ] as? String
                        self.ipv6PTR.text = dict[ "ptr" ] as? String
                        self.ipv6ASN.text = dict[ "asn" ] as? String
                        self.ipv6Country.text = dict[ "country" ] as? String
                        self.ipv6Description.text = dict[ "desc" ] as? String
                    }
                    else
                    {
                        self.ipv6Address.text = "—"
                        self.ipv6PTR.text = "—"
                        self.ipv6ASN.text = "—"
                        self.ipv6Country.text = "—"
                        self.ipv6Description.text = "—"
                    }
                    
                    // Did other request already finish?
                    if( ipv4Done )
                    {
                        // Remove network acitivity indicator and reset "Pull to refresh"
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.refreshControl?.endRefreshing()
                    }
                    else
                    {
                        ipv6Done = true;
                    }
                }
            }
        }
        
    }
    
    
    // Tap on information cell
    override func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath )
    {
        // Determine taped cell
        let cell = tableView.cellForRowAtIndexPath( indexPath )
        
        // Copy content to clipboard
        if let text = cell?.detailTextLabel!.text
        {
            UIPasteboard.generalPasteboard().string = text
        }
        
        // Unselect cell again
        tableView.deselectRowAtIndexPath( indexPath, animated: true )
    }
}

