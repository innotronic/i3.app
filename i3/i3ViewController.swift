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
        self.refreshControl?.addTarget( self, action: #selector(i3ViewController.updateInfo), forControlEvents: UIControlEvents.ValueChanged )
        
        
        // Notification if app becomes active
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(i3ViewController.updateInfo),
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
                        self.ipv4Address.text = dict[ "ip" ] as? String ?? "–"
                        self.ipv4PTR.text = dict[ "ptr" ] as? String ?? "–"
                        self.ipv4ASN.text = dict[ "asn" ] as? String ?? "–"
                        self.ipv4Country.text = dict[ "country" ] as? String ?? "–"
                        self.ipv4Description.text = dict[ "desc" ] as? String ?? "–"
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
                        self.ipv6Address.text = dict[ "ip" ] as? String ?? "–"
                        self.ipv6PTR.text = dict[ "ptr" ] as? String ?? "–"
                        self.ipv6ASN.text = dict[ "asn" ] as? String ?? "–"
                        self.ipv6Country.text = dict[ "country" ] as? String ?? "–"
                        self.ipv6Description.text = dict[ "desc" ] as? String ?? "–"
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
    
    
    @IBAction func doCopyIPv4Address()
    {
        NSLog( "IPv4 Address: %@", ipv4Address.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv4Address.text
    }
    
    @IBAction func doCopyIPv4PTR()
    {
        NSLog( "IPv4 PTR: %@", ipv4PTR.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv4PTR.text
    }
    
    @IBAction func doCopyIPv4ASN()
    {
        NSLog( "IPv4 ASN: %@", ipv4ASN.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv4ASN.text
    }
    
    @IBAction func doCopyIPv4Country()
    {
        NSLog( "IPv4 Country: %@", ipv4Country.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv4Country.text
    }
    
    @IBAction func doCopyIPv4Description()
    {
        NSLog( "IPv4 Description: %@", ipv4Description.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv4Description.text
    }
    
    @IBAction func doCopyIPv6Address()
    {
        NSLog( "IPv6 Address: %@", ipv6Address.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv6Address.text
    }
    
    @IBAction func doCopyIPv6PTR()
    {
        NSLog( "IPv6 PTR: %@", ipv6PTR.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv6PTR.text
    }
    
    @IBAction func doCopyIPv6ASN()
    {
        NSLog( "IPv6 ASN: %@", ipv6ASN.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv6ASN.text
    }
    
    @IBAction func doCopyIPv6Country()
    {
        NSLog( "IPv6 Country: %@", ipv6Country.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv6Country.text
    }
    
    @IBAction func doCopyIpv6Description()
    {
        NSLog( "IPv6 Description: %@", ipv6Description.text ?? "—" )
        UIPasteboard.generalPasteboard().string = ipv6Description.text
    }
}

