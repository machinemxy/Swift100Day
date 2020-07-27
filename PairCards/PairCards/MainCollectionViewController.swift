//
//  MainCollectionViewController.swift
//  PairCards
//
//  Created by Ma Xueyuan on 2020/07/27.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    let reuseIdentifier = "card"
    var cards = [Card]()
    var firstIndexPath: IndexPath?
    var stopped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // create cards
        cards.append(Card(imageName: "ball"))
        cards.append(Card(imageName: "ball"))
        cards.append(Card(imageName: "banana"))
        cards.append(Card(imageName: "banana"))
        cards.append(Card(imageName: "finish"))
        cards.append(Card(imageName: "finish"))
        cards.append(Card(imageName: "monkey"))
        cards.append(Card(imageName: "monkey"))
        cards.append(Card(imageName: "penguin"))
        cards.append(Card(imageName: "penguin"))
        cards.append(Card(imageName: "bomb"))
        cards.append(Card(imageName: "bomb"))
        cards.append(Card(imageName: "star"))
        cards.append(Card(imageName: "star"))
        cards.append(Card(imageName: "vortex"))
        cards.append(Card(imageName: "vortex"))
        cards.shuffle()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCollectionViewCell
    
        cell.imageView.image = UIImage(named: "unknown")
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 4
        let spaceBetweenCells: CGFloat = 10
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if stopped {
            return false
        } else {
            return !cards[indexPath.item].showed
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cards[indexPath.item].showed = true
        let isFirstCard: Bool
        if firstIndexPath == nil {
            isFirstCard = true
            firstIndexPath = indexPath
        } else {
            isFirstCard = false
        }
        
        let currentCell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let currentImageView = currentCell.imageView!
        
        UIView.animate(withDuration: 0.25, animations: {
            currentImageView.transform = CGAffineTransform(scaleX: 0.01, y: 1)
        }) { (completed) in
            currentImageView.image = UIImage(named: self.cards[indexPath.item].imageName)
            UIView.animate(withDuration: 0.25, animations: {
                currentImageView.transform = .identity
            }) { (completed) in
                if !isFirstCard {
                    self.judge(secondIndexPath: indexPath)
                }
            }
        }
    }
    
    func judge(secondIndexPath: IndexPath) {
        guard let firstIndexPath = firstIndexPath else { fatalError() }
        let firstCard = cards[firstIndexPath.item]
        let secondCard = cards[secondIndexPath.item]
        if firstCard.imageName == secondCard.imageName {
            // two same cards
            self.firstIndexPath = nil
            
            if cards.filter({ $0.showed }).count == 16 {
                // game over
                let ac = UIAlertController(title: "Congratulations!", message: "You found all pairs!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true)
            }
        } else {
            // two different cards, give player 0.5 second to remember
            stopped = true
            let firstCell = collectionView.cellForItem(at: firstIndexPath) as! CardCollectionViewCell
            let secondCell = collectionView.cellForItem(at: secondIndexPath) as! CardCollectionViewCell
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.25, animations: {
                    firstCell.imageView.transform = CGAffineTransform(scaleX: 0.01, y: 1)
                    secondCell.imageView.transform = CGAffineTransform(scaleX: 0.01, y: 1)
                }) { (completed) in
                    firstCell.imageView.image = UIImage(named: "unknown")
                    secondCell.imageView.image = UIImage(named: "unknown")
                    UIView.animate(withDuration: 0.25, animations: {
                        firstCell.imageView.transform = .identity
                        secondCell.imageView.transform = .identity
                    }) { (completed) in
                        self.stopped = false
                        self.cards[firstIndexPath.item].showed = false
                        self.cards[secondIndexPath.item].showed = false
                        self.firstIndexPath = nil
                    }
                }
            }
        }
    }
}
