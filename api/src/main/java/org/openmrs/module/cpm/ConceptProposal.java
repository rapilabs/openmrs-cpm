package org.openmrs.module.cpm;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name="concept_proposal_cpm")
public class ConceptProposal {

	private Long id;

	private String title;

	private String proposersName;

	private String proposersEmail;

	private String description;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getProposersName() {
		return proposersName;
	}

	public void setProposersName(String proposersName) {
		this.proposersName = proposersName;
	}

	public String getProposersEmail() {
		return proposersEmail;
	}

	public void setProposersEmail(String proposersEmail) {
		this.proposersEmail = proposersEmail;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
}
