//
//  ViewController.swift
//  Proyecto2MPOO
//
//  Created by 2020-1 on 11/4/19.
//  Copyright © 2019 Omar Rios. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    var puntosList: [Direccion] = []
    var viajeList: [Direccion] = []
    var selectedAn: Direccion?
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var etiqueta: UILabel!
    @IBOutlet weak var botonSegmentado: UISegmentedControl!
    
    let searchBarController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        arreglarZoom()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBarController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "CU"
        
        searchBarController.searchBar.delegate = self
        searchBarController.dimsBackgroundDuringPresentation = false
        etiqueta.text = "Seleccione el punto de partida"
        etiqueta.backgroundColor = .init(white: 0.2, alpha: 0.5)
        etiqueta.layer.masksToBounds = true
        etiqueta.layer.cornerRadius = 15
        botonSegmentado.tintColor = .init(white: 0.2, alpha: 0.9)
    }
    
    
    func getPuntos(nombre: String){
        
        puntosList.removeAll()
        let path = Bundle.main.path(forResource: "points", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        let puntos = try! JSONDecoder().decode([Punto].self, from: jsonData! as Data)
            for punto in puntos{
                if (punto.title.starts(with: nombre)){
                    let coordenada = CLLocationCoordinate2D(latitude: punto.Latitude, longitude: punto.Longitude)
                        let tempPin = Direccion(title: punto.title, coordinate: coordenada)
                        self.puntosList.append(tempPin)
                }
                mapa.addAnnotations(puntosList)
        }
            
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arreglarZoom()
        mapa.removeAnnotations(puntosList)
        mapa.removeOverlays(mapa.overlays)
        
        getPuntos(nombre: searchText)
    }
    
    func crearRuta(inicio: [MKAnnotation]){
        mapa.removeAnnotations(puntosList)
        mapa.addAnnotations(inicio)
        let inicioPlacemark = MKPlacemark(coordinate: inicio.first!.coordinate)
        let destinoPlacemark = MKPlacemark(coordinate: inicio[1].coordinate)
        
        
        let directionRequest = MKDirections.Request()
        
        directionRequest.source = MKMapItem(placemark: inicioPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinoPlacemark)
        directionRequest.transportType = .walking
        
        let directions: MKDirections = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let directionResponse = response else {
                return
            }
            
            let ruta = directionResponse.routes.first
            self.mapa.addOverlay(ruta!.polyline)
            let rect = ruta?.polyline.boundingMapRect
            self.mapa.setRegion(MKCoordinateRegion(rect!), animated: true)
            self.viajeList.removeAll()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let linea = MKPolylineRenderer(overlay: overlay)
        linea.strokeColor = .green
        linea.lineWidth = 4.0
        return linea
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedAn = view.annotation as? Direccion
        viajeList.append(selectedAn!)
        let n = viajeList.count
        
        switch n {
        case 1:
            etiqueta.text = "Inicio: \((viajeList.first?.title)!)\n Escoge tu destino"
        case 2:
            etiqueta.text = "Buen viaje krnal"
            crearRuta(inicio: viajeList)
        default:
            return
            
        }
    }
    
    @IBAction func cambiar(_ sender: UISegmentedControl) {
        switch botonSegmentado.selectedSegmentIndex
        {
        case 0:
            mapa.mapType = .standard
            botonSegmentado.tintColor = .init(white: 0.2, alpha: 0.9)
        case 1:
            mapa.mapType = .hybrid
            botonSegmentado.tintColor = .white
        default:
            break
        }
    }
    
    func arreglarZoom() {
        let fi = CLLocation(latitude: 19.331656, longitude: -99.184721)
        let radio: CLLocationDistance = 3000.0
        let region = MKCoordinateRegion(center: fi.coordinate, latitudinalMeters: radio, longitudinalMeters: radio)
        mapa.setRegion(region, animated: true)
    }
    
    
}







        
    





