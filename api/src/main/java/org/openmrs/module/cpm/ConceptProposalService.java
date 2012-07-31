package org.openmrs.module.cpm;

import org.springframework.transaction.annotation.Transactional;

@Transactional
public interface ConceptProposalService {

	public void setFormEntryDAO(ConceptProposalDAO dao);

}
