//
//  MainRowSubView.swift
//  movieapp
//
//  Created by miguel tomairo on 9/03/25.
//

import SwiftUI

struct MainRowSubView: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 16) {
            moviePoster
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                HStack {
                    Label(movie.formattedReleaseDate, systemImage: "calendar")
                    Spacer()
                    Label(movie.formattedRating, systemImage: "star.fill")
                        .foregroundColor(.yellow)
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var moviePoster: some View {
        Group {
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "film")
                            .foregroundColor(.gray)
                    @unknown default:
                        Image(systemName: "film")
                            .foregroundColor(.gray)
                    }
                }
            } else {
                Image(systemName: "film")
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 80, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    MainRowSubView(movie: Movie(
        id: 1,
        title: "Película de ejemplo",
        overview: "Esta es una descripción de ejemplo para una película. Contiene información sobre la trama y otros detalles interesantes.",
        posterPath: nil,
        releaseDate: "2023-01-01",
        rating: 8.5
    ))
    .padding()
}
