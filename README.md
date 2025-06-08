# Tokenized Arts Cultural Heritage Preservation

A comprehensive blockchain-based system for preserving and managing cultural heritage artifacts using Clarity smart contracts on the Stacks blockchain.

## Overview

This project provides a decentralized platform for cultural institutions to document, preserve, and manage access to cultural heritage artifacts. The system includes funding mechanisms, educational programs, and robust access controls.

## Smart Contracts

### 1. Institution Verification Contract (`institution-verification.clar`)
- **Purpose**: Validates and manages cultural institutions
- **Key Features**:
    - Institution registration
    - Verification process by contract owner
    - Status tracking and management
    - Contact information storage

### 2. Artifact Documentation Contract (`artifact-documentation.clar`)
- **Purpose**: Documents and manages cultural artifacts
- **Key Features**:
    - Comprehensive artifact metadata storage
    - IPFS integration for media files
    - Institution association
    - Update capabilities for authorized users

### 3. Preservation Funding Contract (`preservation-funding.clar`)
- **Purpose**: Manages funding for cultural preservation projects
- **Key Features**:
    - Project creation and management
    - Crowdfunding capabilities
    - Contribution tracking
    - Project completion status

### 4. Access Management Contract (`access-management.clar`)
- **Purpose**: Controls public access to cultural heritage
- **Key Features**:
    - Three-tier access levels (public, restricted, private)
    - User permission management
    - Institution-based access control
    - Artifact-specific permissions

### 5. Educational Program Contract (`educational-program.clar`)
- **Purpose**: Coordinates cultural education programs
- **Key Features**:
    - Program creation and management
    - Enrollment system with capacity limits
    - Completion tracking
    - Instructor management

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd cultural-heritage-preservation
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

## Usage Examples

### Registering an Institution
\`\`\`clarity
(contract-call? .institution-verification register-institution
"Metropolitan Museum"
"1000 5th Ave, New York, NY"
"contact@metmuseum.org")
\`\`\`

### Documenting an Artifact
\`\`\`clarity
(contract-call? .artifact-documentation document-artifact
"Ancient Vase"
"A beautiful ceramic vase from the Ming Dynasty"
"China"
"1400-1450 CE"
u1
"QmXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx"
"ceramic")
\`\`\`

### Creating a Funding Project
\`\`\`clarity
(contract-call? .preservation-funding create-funding-project
"Restore Ancient Manuscripts"
"Project to digitize and restore 15th century manuscripts"
u1
u50000)
\`\`\`

## Access Levels

- **Public**: Accessible to all users
- **Restricted**: Requires specific permissions
- **Private**: Institution-only access

## Testing

The project includes comprehensive tests using Vitest:

\`\`\`bash
npm run test
\`\`\`

Tests cover:
- Contract deployment
- Function execution
- Error handling
- Access control
- Data integrity

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the GitHub repository.

