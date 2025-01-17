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
    @IBOutlet weak var ViewDaftarBarang: UILabel!
    @IBOutlet weak var ViewTanggalKadaluarsaTerdekat: UILabel!
    @IBOutlet weak var ViewBarangTop1: UILabel!
    @IBOutlet weak var ViewGambarTop1: UIImageView!
    @IBOutlet weak var ViewBarangTop2: UILabel!
    @IBOutlet weak var ViewGambarTop2: UIImageView!
    @IBOutlet weak var ViewBarangTop3: UILabel!
    @IBOutlet weak var ViewGambarTop3: UIImageView!
    @IBOutlet weak var ViewUsername: UILabel!
    
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

