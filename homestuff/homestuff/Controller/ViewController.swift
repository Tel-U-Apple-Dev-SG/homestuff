//
//  ViewController.swift
//  homestuff
//
//  Created by Muhammad Daffa Izzati on 17/01/25.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var VIewTotalBarang: UILabel!
    
    @IBOutlet weak var ViewBarangKadaluarsaTerdekat: UILabel!
    
    override func viewDidLoad()
    {            super.viewDidLoad()
        
    }
    

    @IBAction func ProfilePIcturePressed(_ sender: UIButton) {
        print("Profile picture Pressed")
    }
    
    
    @IBAction func CheckSelengkapnyaPressed(_ sender: UIButton) {
        print("Check selengkapnya tapped")
    }
    
    @IBAction func AddItemPressed(_ sender: UIButton) {
        print("Tambah barang tapped")
    }
    
    @IBAction func InfoAppPressed(_ sender: UIButton) {
        print("Info App tapped")
    }
    
    @IBAction func SearchItemPressed(_ sender: Any) {
        print("Search tapped")
    }
    
    @IBAction func NotificationPressed(_ sender: UIButton) {
        print("Notifikasi tapped")
    }
    
    @IBAction func HistoryItemAddedPressed(_ sender: Any) {
        print("Histori barang tapped")
    }
}

