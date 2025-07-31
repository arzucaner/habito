import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
        }
    }
    
    func triggerAnimation() {
        isAnimating = true
        createParticles()
        
        withAnimation(.easeOut(duration: 2.0)) {
            for i in particles.indices {
                particles[i].position.y += 400
                particles[i].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isAnimating = false
            particles.removeAll()
        }
    }
    
    private func createParticles() {
        particles.removeAll()
        
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
        
        for _ in 0..<50 {
            let particle = ConfettiParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 50...350),
                    y: CGFloat.random(in: 100...200)
                ),
                color: colors.randomElement() ?? .red,
                size: CGFloat.random(in: 5...15),
                opacity: 1.0
            )
            particles.append(particle)
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
    var opacity: Double
}

#Preview {
    ConfettiView()
} 